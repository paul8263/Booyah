//
//  TaskDetailTableViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 4/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TaskDetailTableViewController: UITableViewController {
    
    var task: Task!
    let currentUser = FIRAuth.auth()?.currentUser
    let chatGroupsRef = FIRDatabase.database().reference(withPath: "chatGroups")
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    var chatGroupToStart: ChatGroup?
    
    @IBOutlet weak var titleCell: UITableViewCell!
    @IBOutlet weak var descriptionCell: UITableViewCell!
    @IBOutlet weak var addressCell: UITableViewCell!
    @IBOutlet weak var dateCell: UITableViewCell!
    @IBOutlet weak var modifyButton: UIBarButtonItem!
    @IBOutlet weak var startChatButton: UIButton!
    
    private func startChat() {
        var currentUserChatGroups = [String]()
        var otherUserChatGroups = [String]()
        usersRef.child(currentUser!.uid).child("chatGroups").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                self.createNewChatGroup()
            } else {
                let currentUserSnapshotValue = snapshot.value as! [String: Any]
                self.usersRef.child(self.task.userId).child("chatGroups").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.value is NSNull {
                        self.createNewChatGroup()
                    } else {
                        let otherUserSnapshotValue = snapshot.value as! [String: Any]
                        for (key, _) in currentUserSnapshotValue {
                            currentUserChatGroups.append(key)
                        }
                        for (key, _) in otherUserSnapshotValue {
                            otherUserChatGroups.append(key)
                        }
                        for i in currentUserChatGroups {
                            for j in otherUserChatGroups {
                                if i == j {
                                    ChatGroup.getFromDatabaseById(chatGroupId: i, completion: { (chatGroup) in
                                        self.chatGroupToStart = chatGroup
                                        self.performSegue(withIdentifier: "StartChatSegue", sender: nil)
                                    })
                                    return
                                }
                            }
                        }
                        self.createNewChatGroup()
                    }
                })
            }
        })
    }
    
    private func createNewChatGroup() {
        let newChatGroup = ChatGroup(isActive: true, groupName: task.title, users: [self.currentUser!.uid, self.task.userId])
        newChatGroup.save()
        let newChatGroupId = newChatGroup.chatGroupId
        User.addChatGroupWithUserId(userId: self.currentUser!.uid, chatGroupId: newChatGroupId)
        User.addChatGroupWithUserId(userId: self.task.userId, chatGroupId: newChatGroupId)
        
        self.chatGroupToStart = newChatGroup
        self.performSegue(withIdentifier: "StartChatSegue", sender: newChatGroupId)
    }
    
    @IBAction func chatButtonTouched(_ sender: UIButton) {
        startChat()
    }
        
    @IBAction func modifyButtonTouched(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ModifyTaskSegue", sender: nil)
    }
    
    private func setUpTableView() {
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func loadDataToCell() {
        titleCell.textLabel?.text = task.title
//        let attributedString = NSMutableAttributedString(string: task.description)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 20
//        attributedString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSRange(location: 0, length: attributedString.length))
//        descriptionCell.textLabel?.numberOfLines = 0
//        descriptionCell.textLabel?.lineBreakMode = .byWordWrapping
//        descriptionCell.textLabel?.attributedText = attributedString
//        descriptionCell.sizeToFit()
        descriptionCell.textLabel?.text = task.description
        
        addressCell.textLabel?.text = task.address
//        Format the date, and at the same time convert the time zone from UTC to current setting
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        dateCell.textLabel?.text = dateFormatter.string(from: task.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if task.userId != currentUser!.uid {
            modifyButton.isEnabled = false
        } else {
            startChatButton.isEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationItem.title = task.title
        loadDataToCell()
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModifyTaskSegue" {
            let navigationController = segue.destination as! UINavigationController
            let addModifyTaskTableViewController = navigationController.viewControllers.first as! AddModifyTaskTableViewController
            addModifyTaskTableViewController.isAddingTask = false
            addModifyTaskTableViewController.task = task
            addModifyTaskTableViewController.delegate = self
        } else if segue.identifier == "StartChatSegue" {
            let chatRoomViewController = segue.destination as! ChatRoomViewController
            
            guard let chatGroupToStart = self.chatGroupToStart else {
                fatalError( #function + " chatGroupToStart is nil")
            }
            chatRoomViewController.chatGroup = chatGroupToStart
            chatRoomViewController.senderId = self.currentUser!.uid
//            Will change it to display name later
            chatRoomViewController.senderDisplayName = currentUser!.email
        }
    }
}

extension TaskDetailTableViewController: AddModifyTaskTableViewControllerDelegate {
    func taskDidAddedOrModified(newTask: Task) {
        self.task = newTask
    }
}
