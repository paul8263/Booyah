//
//  ChatRoomViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 4/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseDatabase
import FirebaseAuth

class ChatRoomViewController: JSQMessagesViewController {
    
    let currentUser = FIRAuth.auth()?.currentUser
    let chatGroupRef = FIRDatabase.database().reference(withPath: "chatGroups")
    let messagesRef = FIRDatabase.database().reference(withPath: "messages")
    var chatGroup: ChatGroup?
    
    var messageList = [JSQMessage]()
    
    var outgoingMessageBubbleImage: JSQMessagesBubbleImage!
    var incomingMessageBubbleImage: JSQMessagesBubbleImage!
    
    func snapshotToJSQMessage(snapshot: FIRDataSnapshot) -> JSQMessage {
        let snapshotValue = snapshot.value as! [String: Any]
        var msgSenderId = ""
        var msgDate = Date()
        var msgText = ""
        var msgSenderDisplayName = ""
        if let senderId = snapshotValue["senderId"] as? String {
            msgSenderId = senderId
        }
        if let timestamp = snapshotValue["timestamp"] as? Double {
            msgDate = Date(timeIntervalSince1970: timestamp)
        }
        if let text = snapshotValue["text"] as? String {
            msgText = text
        }
        if let senderDisplayName = snapshotValue["senderDisplayName"] as? String {
            msgSenderDisplayName = senderDisplayName
        }
        return JSQMessage(senderId: msgSenderId, senderDisplayName: msgSenderDisplayName, date: msgDate, text: msgText)
    }
    func messageToDatabase(message: JSQMessage) {
        let chatGroupId = chatGroup?.chatGroupId
        let currentChatRoomMessagesRef = messagesRef.child(chatGroupId!)
        let currentMessageRef = currentChatRoomMessagesRef.childByAutoId()
        var messageData: [String: Any] = ["senderId": self.senderId]
        if let messageText = message.text {
            messageData["text"] = messageText
        }
        if let date = message.date {
            messageData["timestamp"] = date.timeIntervalSince1970
        }
        if let senderId = message.senderId {
            messageData["senderId"] = senderId
        }
        messageData["senderDisplayName"] = senderDisplayName
        currentMessageRef.setValue(messageData)
    }
    
//    private func loadMessages() {
//        self.messageList = []
//        let chatGroupId = chatGroup?.chatGroupId
//        let currentChatRoomMessagesRef = messagesRef.child(chatGroupId!).queryLimited(toLast: 25)
//        currentChatRoomMessagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if snapshot.childrenCount > 0 {
//                for childSnapshot in snapshot.children {
//                    self.messageList.append(self.snapshotToJSQMessage(snapshot: childSnapshot as! FIRDataSnapshot))
//                }
//                self.collectionView.reloadData()
//            }
//        })
//    }
    
    private func observeAddedMessage() {
        let chatGroupId = chatGroup?.chatGroupId
        let currentChatRoomMessagesRef = messagesRef.child(chatGroupId!)
        currentChatRoomMessagesRef.observe(.childAdded, with: { (snapshot) in
            self.messageList.append(self.snapshotToJSQMessage(snapshot: snapshot))
            self.collectionView.reloadData()
        })
    }
    
    private func setUpBubbles() {
        let factory = JSQMessagesBubbleImageFactory()!
        outgoingMessageBubbleImage = factory.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        incomingMessageBubbleImage = factory.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
//    Todo
    private func setUpAvatar() {
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpBubbles()
        setUpAvatar()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.messageList.removeAll()
//        loadMessages()
        observeAddedMessage()
        self.chatGroup?.getGroupDisplayName(currentUser: self.currentUser!, completionHandler: { (name) in
            self.navigationItem.title =  name
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messageList[indexPath.row]
        if message.senderId == self.senderId {
            return outgoingMessageBubbleImage
        } else {
            return incomingMessageBubbleImage
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messageList[indexPath.row]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messageList[indexPath.row]
        if message.senderId == self.senderId {
            cell.textView.textColor = UIColor.white
        } else {
            cell.textView.textColor = UIColor.black
        }
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messageList[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return NSAttributedString(string: formatter.string(from: message.date))
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 13
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let message = JSQMessage(senderId: self.senderId, senderDisplayName: senderDisplayName, date: Date(), text: text)!
        messageToDatabase(message: message)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
    }
}
