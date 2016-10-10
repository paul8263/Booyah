//
//  User.swift
//  Booyah
//
//  Created by Paul Zhang on 4/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class User {
    static let userBaseRef = FIRDatabase.database().reference(withPath: "users")
    var userId: String
    var displayName: String
    var email: String
    var chatGroups: [String]?
    var tasks: [String]?
    var ref: FIRDatabaseReference?
    
    init(userId: String, displayName: String = "", email: String = "") {
        self.userId = userId
        self.displayName = displayName
        self.email = email
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.userId = snapshot.key
        if let displayName = snapshotValue["displayName"] as? String {
            self.displayName = displayName
        } else {
            self.displayName = ""
        }
        if let email = snapshotValue["email"] as? String {
            self.email = email
        } else {
            self.email = ""
        }
        self.ref = snapshot.ref
        if snapshotValue["chatGroups"] is NSNull {
            self.chatGroups = []
        } else {
            var newChatGroups = [String]()
            let chatGroupsDict = snapshotValue["chatGroups"] as! [String: Any]
            for (key, _) in chatGroupsDict {
                newChatGroups.append(key)
            }
            self.chatGroups = newChatGroups
        }
    }
    
    init(fromFIRUser: FIRUser) {
        if let email = fromFIRUser.email {
            self.email = email
        } else {
            self.email = ""
        }
        if let displayName = fromFIRUser.displayName {
            self.displayName = displayName
        } else {
            self.displayName = ""
        }
        self.userId = fromFIRUser.uid
        self.chatGroups = [String]()
        self.tasks = [String]()
    }
    
    func toDict() -> [String: Any] {
        var userDict: [String: Any] = ["email": self.email]
        var chatGroupsDict = [String: Any]()
        var tasksDict = [String: Any]()
        if let chatGroups = self.chatGroups {
            if chatGroups.count > 0 {
                for chatGroup in chatGroups {
                    chatGroupsDict[chatGroup] = true
                }
            }
        }
        if let tasks = self.tasks {
            if tasks.count > 0 {
                for task in tasks {
                    tasksDict[task] = true
                }
            }
        }
        userDict["chatGroups"] = chatGroupsDict
        userDict["tasks"] = tasksDict
        return userDict
    }
    func save() {
        var newUserRef: FIRDatabaseReference!
        if self.userId == "" {
            newUserRef = User.userBaseRef.childByAutoId()
        } else {
            newUserRef = User.userBaseRef.child(self.userId)
        }
        newUserRef.setValue(self.toDict())
        self.userId = newUserRef.key
        self.ref = newUserRef
    }
    
}
