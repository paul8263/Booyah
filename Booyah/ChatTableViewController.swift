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
    
//    Will be removed
    var userList = [User]()
    
    var chatGroupList = [ChatGroup]()
    
//    Will be removed
    private func loadUsers() {
        userList += [
            User(userId: "0", displayName: "Paul"),
            User(userId: "1", displayName: "Kate"),
        ]
    }
    
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
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        loadUsers()
        loadChatGroups()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
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

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            userList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ChatRoomSegue" {
            let indexPath = sender as! IndexPath
            let chatRoomViewController = segue.destination as! ChatRoomViewController
//            chatRoomViewController.chattingWithUser = chatGroupList[indexPath.row]
            chatRoomViewController.chatGroup = chatGroupList[indexPath.row]
//            Todo
            chatRoomViewController.senderId = currentUser!.uid
            chatRoomViewController.senderDisplayName = currentUser!.email!
        }
    }
    

}
