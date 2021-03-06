//
//  MyInfoTableViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 4/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class MyInfoTableViewController: UITableViewController {
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var currentUser = FIRAuth.auth()?.currentUser
    
    let usersBaseRef = FIRDatabase.database().reference(withPath: "users")
    let chatGroupsRef = FIRDatabase.database().reference(withPath: "chatGroups")
    let messagesRef = FIRDatabase.database().reference(withPath: "messages")
    
    private func isLoggedIn() -> Bool {
        return self.currentUser != nil
    }
    
    private func loadAvatar() {
//        User.loadAvatar(forUserId: self.currentUser!.uid) { (data, error) in
//            if error != nil {
//                print("Avatar not set")
//            } else {
//                if let data = data {
//                    let avatarImage = UIImage(data: data)
//                    self.avatarImageView.image = avatarImage
//                }
//            }
//        }
        User.getAvatarDownloadURL(forUserId: self.currentUser!.uid) { (url, error) in
            if error != nil {
                print("Avatar not set")
            } else {
                self.avatarImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "default_avatar"))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.displayNameLabel.text = self.currentUser?.email
        loadAvatar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func clearChatLog() {
        if isLoggedIn() {
            usersBaseRef.child(self.currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                if let chatGroups = user.chatGroups {
                    for chatGroup in chatGroups {
                        self.chatGroupsRef.child(chatGroup).observeSingleEvent(of: .value, with: {(snapshot) in
                            let chatGroup = ChatGroup(snapshot: snapshot)
                            let userIds: [String] = chatGroup.users
                            for userId in userIds {
                                User.removeChatGroupWithUserId(userId: userId, chatGroupId: chatGroup.chatGroupId)
                            }
                            chatGroup.delete()
                            self.messagesRef.child(chatGroup.chatGroupId).removeValue()
                        })
                    }
                }
            })
        } else {
            print("Login required")
        }
        
    }
    
    private func logOut() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch {
            print("########Sign out error")
        }
        performSegue(withIdentifier: "LogoutSegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 3 {
            performSegue(withIdentifier: "ShowMyTaskSegue", sender: nil)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
            
        } else if indexPath.section == 1 && indexPath.row == 1 {
            performSegue(withIdentifier: "ChangePasswordSegue", sender: nil)
        } else if indexPath.section == 1 && indexPath.row == 2 {
            let alertController = UIAlertController(title: "Clear Chat Log", message: "Your chat log will be cleared. Are you sure?", preferredStyle: UIAlertControllerStyle.actionSheet)
            let confirmAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: { (action) in
                self.clearChatLog()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        } else if indexPath.section == 1 && indexPath.row == 3 {
            let alertController = UIAlertController(title: "Log Out", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.actionSheet)
            let confirmAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: { (action) in
                self.logOut()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        } else {
            self.tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMyTaskSegue" {
            let taskTableViewController = segue.destination as! TaskTableViewController
            taskTableViewController.isShowingTasksForCurrentUserOnly = true
        }
    }
}
extension MyInfoTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.avatarImageView.image = image
            User.setAvatar(forUserId: self.currentUser!.uid, image: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
