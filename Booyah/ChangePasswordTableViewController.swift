//
//  ChangePasswordTableViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 7/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChangePasswordTableViewController: UITableViewController {
    @IBOutlet weak var emailCell: UITableViewCell!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    var currentUser: FIRUser?
    
    @IBAction func doneButtonTouched(_ sender: UIBarButtonItem) {
        if isValidate() {
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: currentUser!.email!, password: oldPasswordTextField.text!)
            currentUser?.reauthenticate(with: credential, completion: { (error) in
                if error != nil {
                    print("Old password error")
                } else {
                    self.currentUser?.updatePassword(self.newPasswordTextField.text!, completion: { (error) in
                        if error != nil {
                            print("Change password Error")
                        } else {
                            print("Change password Success")
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                }
            })
        } else {
            print("Invalid password")
        }
    }
    
    private func isValidate() -> Bool {
//        Todo
        return true
    }

    private func loadUserEmail() {
        guard let user = currentUser else {
            print("User is not logged in")
            return
        }
        emailCell.textLabel?.text = user.email
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.currentUser = FIRAuth.auth()?.currentUser
        loadUserEmail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 1 && indexPath.row == 0 {
            oldPasswordTextField.becomeFirstResponder()
        } else if indexPath.section == 1 && indexPath.row == 1 {
            newPasswordTextField.becomeFirstResponder()
        }
    }
}
