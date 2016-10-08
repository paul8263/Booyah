//
//  MyInfoTableViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 4/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import FirebaseAuth

class MyInfoTableViewController: UITableViewController {
    
    var currentUser: FIRUser?
    
    private func loadUser() {
        currentUser = FIRAuth.auth()?.currentUser
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func clearChatLog() {
        
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
        } else if indexPath.section == 1 && indexPath.row == 1 {
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
        } else if indexPath.section == 1 && indexPath.row == 0 {
            performSegue(withIdentifier: "ChangePasswordSegue", sender: nil)
        } else if indexPath.section == 1 && indexPath.row == 2 {
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
