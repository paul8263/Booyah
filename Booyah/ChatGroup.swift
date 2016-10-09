//
//  ChatGroup.swift
//  Booyah
//
//  Created by Paul Zhang on 8/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class ChatGroup {
    var chatGroupId: String
    var isActive: Bool
    var groupName: String
    var users: [String]
    var ref: FIRDatabaseReference?
    
    init(chatGroupId: String = "", isActive: Bool = true, groupName: String = "", users: [String] = []) {
        self.chatGroupId = chatGroupId
        self.isActive = isActive
        self.groupName = groupName
        self.users = users
    }
    init(snapshot: FIRDataSnapshot) {
        self.ref = snapshot.ref
        self.chatGroupId = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        self.isActive = snapshotValue["isActive"] as! Int == 1 ? true: false
        self.groupName = snapshotValue["groupName"] as! String
        let usersDict = snapshotValue["users"] as! [String: Any]
        self.users = [String]()
        for (key, _) in usersDict {
            users.append(key)
        }
    }
//    init(dict: [String: Any]) {
//        
//    }
//    
//    func toDict() -> [String: Any] {
//        
//    }
    
//    Return the name of the other user
    func getGroupDisplayName(currentUser: FIRUser, completionHandler: @escaping (String) -> Void) {
        for user in users {
            if currentUser.uid != user {
                FIRDatabase.database().reference(withPath: "users").queryOrderedByKey().queryEqual(toValue: user).observeSingleEvent(of: .value, with: { (snapshot) in
                    let snap = snapshot.children.allObjects[0] as! FIRDataSnapshot
                    let snapValue = snap.value as! [String: Any]
                    let result = snapValue["email"] as! String
                    completionHandler(result)
                })
            }
        }
    }
    func save() {
        
    }
}
