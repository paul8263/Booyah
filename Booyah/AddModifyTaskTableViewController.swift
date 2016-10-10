//
//  AddModifyTaskTableViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 6/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddModifyTaskTableViewController: UITableViewController {
    
    let userBaseRef = FIRDatabase.database().reference(withPath: "users")
    var currentUser = FIRAuth.auth()?.currentUser
    
    var isAddingTask = false
    var task: Task?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
        
    @IBAction func cancelButtonTouched(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func isLoggedIn() -> Bool {
        return self.currentUser != nil
    }
    
    private func addNewTaskToFirebase() {
        if isLoggedIn() {
            let task = createOrUpdateTaskFromView(oldTask: nil)
            task.save()
            let taskId = task.ref!.key
            let userTaskRef = userBaseRef.child(currentUser!.uid).child("tasks").child(taskId)
            userTaskRef.setValue(true)
        } else {
            print("User is not logged in")
        }
    }
    
    private func updateTaskInFirebase() {
        if isLoggedIn() {
            let task = createOrUpdateTaskFromView(oldTask: self.task!)
            task.save()
        } else {
            print("User is not logged in")
        }
    }
    
    private func isValidate() -> Bool {
//        Todo
        return true
    }
    
    @IBAction func doneButtonTouched(_ sender: UIBarButtonItem) {
        if isValidate() {
            if isAddingTask {
                addNewTaskToFirebase()
            } else {
                updateTaskInFirebase()
            }
            dismiss(animated: true, completion: nil)
        } else {
//            Todo
        }
    }
    
    private func loadTask() {
        self.titleTextField.text = task?.title
        self.descriptionTextView.text = task?.description
        self.addressTextField.text = task?.address
        self.taskDatePicker.date = (task?.date)!
    }
    
    private func createOrUpdateTaskFromView(oldTask: Task?) -> Task {
        var returnedTask: Task!
        if let task = oldTask {
            returnedTask = task
        } else {
            returnedTask = Task()
        }
        if let title = self.titleTextField.text {
            returnedTask.title = title
        }
        if let description = self.descriptionTextView.text {
            returnedTask.description = description
        }
        if let address = self.addressTextField.text {
            returnedTask.address = address
        }
        
        returnedTask.date = taskDatePicker.date
        returnedTask.userId = self.currentUser!.uid
        return returnedTask
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if isAddingTask {
            navigationItem.title = "Add Task"
        } else {
            navigationItem.title = task?.title
            loadTask()
        }
        self.taskDatePicker.datePickerMode = .date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}
