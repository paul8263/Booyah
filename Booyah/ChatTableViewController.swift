//
//  ChatTableViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 4/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChatTableViewController: UITableViewController {
    
    let currentUser = FIRAuth.auth()?.currentUser
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    let chatGroupsRef = FIRDatabase.database().reference(withPath: "chatGroups")
    let messagesRef = FIRDatabase.database().reference(withPath: "messages")
    
    var chatGroupList = [ChatGroup]()
    
    private func loadChatGroups() {
        self.chatGroupList.removeAll()
        usersRef.child(currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = User(snapshot: snapshot)
            if let groups = user.chatGroups {
                for chatgroupId in groups {
                    self.chatGroupsRef.child(chatgroupId).observeSingleEvent(of: .value, with: { (snapshot) in
                        let chatGroup = ChatGroup(snapshot: snapshot)
                        self.chatGroupList.append(chatGroup)
                        self.tableView.reloadData()
                    })
                }
            } else {
                self.tableView.reloadData()
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        loadChatGroups()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatGroupList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath)
        cell.textLabel?.text = chatGroupList[indexPath.row].groupName
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ChatRoomSegue", sender: indexPath)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

//    Consider isActive later
    func removeChatGroup(chatGroup: ChatGroup) {
        let userIds: [String] = chatGroup.users
        for userId in userIds {
            User.removeChatGroupWithUserId(userId: userId, chatGroupId: chatGroup.chatGroupId)
        }
        chatGroup.delete()
        messagesRef.child(chatGroup.chatGroupId).removeValue()
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let chatGroupToBeRemoved = self.chatGroupList[indexPath.row]
            removeChatGroup(chatGroup: chatGroupToBeRemoved)
            self.chatGroupList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatRoomSegue" {
            let indexPath = sender as! IndexPath
            let chatRoomViewController = segue.destination as! ChatRoomViewController
            chatRoomViewController.chatGroup = chatGroupList[indexPath.row]
            chatRoomViewController.senderId = currentUser!.uid
            chatRoomViewController.senderDisplayName = currentUser!.email!
        }
    }
    

}
