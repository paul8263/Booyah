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
//    Will be removed
    var chattingWithUser: User!
    
    let currentUser = FIRAuth.auth()?.currentUser
    let chatGroupRef = FIRDatabase.database().reference(withPath: "chatGroups")
    let messagesRef = FIRDatabase.database().reference(withPath: "messages")
    var chatGroupId: String?
    var chatGroup: ChatGroup?
    
    var messageList = [JSQMessage]()
    
    var outgoingMessageBubbleImage: JSQMessagesBubbleImage!
    var incomingMessageBubbleImage: JSQMessagesBubbleImage!
    
    private func loadMessages() {
        messageList += [
            JSQMessage(senderId: "FakedSenderId", displayName: "Paul", text: "Hello Kate"),
            JSQMessage(senderId: "OtherSenderId", displayName: "Kate", text: "Hey Paul"),
        ]
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
    
//    private func loadChatGroup() {
//        chatGroupRef.queryOrderedByKey().queryEqual(toValue: chatGroupId!).observeSingleEvent(of: .value, with: { (snapshot) in
//            if snapshot.childrenCount > 1 {
//                fatalError("Duplicated chat group with same ID")
//            }
//            let snap = snapshot.children.allObjects[0] as! FIRDataSnapshot
//            self.chatGroup = ChatGroup(snapshot: snap)
//            self.chatGroup?.getGroupDisplayName(currentUser: self.currentUser!, completionHandler: { (name) in
//                self.navigationItem.title =  name
//            })
//        })
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadMessages()
        setUpBubbles()
        self.chatGroup?.getGroupDisplayName(currentUser: self.currentUser!, completionHandler: { (name) in
            self.navigationItem.title =  name
        })
        setUpAvatar()
//        loadChatGroup()
        tabBarController?.tabBar.isHidden = true
//        navigationItem.title = senderDisplayName
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
        if message.senderId == senderId {
            return nil
        } else {
            return NSAttributedString(string: message.senderDisplayName)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 13
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let message = JSQMessage(senderId: self.senderId, senderDisplayName: "", date: Date(), text: text)!
        messageList.append(message)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
