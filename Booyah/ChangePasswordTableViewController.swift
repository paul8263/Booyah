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

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
