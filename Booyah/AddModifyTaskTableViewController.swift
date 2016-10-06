//
//  AddModifyTaskTableViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 6/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class AddModifyTaskTableViewController: UITableViewController {
    
    var isAddingTask = false
    var task: Task?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    
    
    @IBAction func cancelButtonTouched(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func addNewTaskToFirebase() {
//        Todo
    }
    
    private func updateTaskInFirebase() {
//        Todo
    }
    
    
    @IBAction func doneButtonTouched(_ sender: UIBarButtonItem) {
        if isAddingTask {
            addNewTaskToFirebase()
        } else {
            updateTaskInFirebase()
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func loadTask() {
        self.titleTextField.text = task?.title
        self.descriptionTextView.text = task?.description
        self.addressTextField.text = task?.address
        
        self.taskDatePicker.date = (task?.date)!
    }
    
    private func createNewTask() -> Task {
        let task = Task()
        if let title = self.titleTextField.text {
            task.title = title
        }
        if let description = self.descriptionTextView.text {
            task.description = description
        }
        if let address = self.addressTextField.text {
            task.address = address
        }
        
        task.date = taskDatePicker.date
        return task
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
