//
//  JSQMessageHelper.swift
//  Booyah
//
//  Created by Paul Zhang on 9/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import FirebaseDatabase

class JSQMessageHelper {
    static let messagesRef = FIRDatabase.database().reference(withPath: "messages")
    static func saveMessageToDatabase(message: JSQMessage, chatGroupId: String) {
        let currentChatRoomMessagesRef = messagesRef.child(chatGroupId)
        let currentMessageRef = currentChatRoomMessagesRef.childByAutoId()
        var messageData: [String: Any] = ["senderId": message.senderId]
        if let messageText = message.text {
            messageData["text"] = messageText
        }
        if let date = message.date {
            messageData["timestamp"] = date.timeIntervalSince1970
        }
        if let senderId = message.senderId {
            messageData["senderId"] = senderId
        }
        messageData["senderDisplayName"] = message.senderDisplayName
        currentMessageRef.setValue(messageData)
    }
    
    static func readMessageFromDatabase(snapshot: FIRDataSnapshot) -> JSQMessage {
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
}
