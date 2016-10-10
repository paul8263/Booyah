//
//  TaskTableViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 4/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TaskTableViewController: UITableViewController {
    
    var ref = FIRDatabase.database().reference(withPath: "tasks")
    let currentUser = FIRAuth.auth()?.currentUser
    var taskList = [Task]()
    var filteredTaskList = [Task]()
    
    var isShowingTasksForCurrentUserOnly = false
    
    var searchController: UISearchController!
    
    func loadTasks() {
        if isShowingTasksForCurrentUserOnly {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                var newTaskList = [Task]()
                for taskSnapshot in snapshot.children {
                    let task = Task(snapshot: taskSnapshot as! FIRDataSnapshot)
                    if task.userId == self.currentUser!.uid {
                        newTaskList.append(task)
                    }
                }
                self.taskList = newTaskList
                self.tableView.reloadData()
                if self.refreshControl!.isRefreshing {
                    self.refreshControl!.endRefreshing()
                }
            })
        } else {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                var newTaskList = [Task]()
                for task in snapshot.children {
                    newTaskList.append(Task(snapshot: task as! FIRDataSnapshot))
                }
                self.taskList = newTaskList
                self.tableView.reloadData()
                if self.refreshControl!.isRefreshing {
                    self.refreshControl!.endRefreshing()
                }
            })
        }
    }
    
    private func isLoggedIn() -> Bool {
        return self.currentUser != nil
    }
    
    private func setUpSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
//        searchController.hidesNavigationBarDuringPresentation = true
//      Hide the search bar when jumped to Task detail view controller after the result cell is touched
//      This is very important, the current view controller will present a search controller over its main view. Setting the definesPresentationContext property to true will indicate that the view controller’s view will be covered each time the search controller is shown over it. This will allow to avoid unknown behaviour.
        self.definesPresentationContext = true
        let searchBar = searchController.searchBar
        searchBar.searchBarStyle = .minimal
        searchBar.sizeToFit()
//        searchBar.barTintColor = UIColor(red:0.95, green:0.95, blue:0.96, alpha:1.00)
        tableView.tableHeaderView = searchBar
    }
    
    private func setUpTableView() {
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 100
        self.tableView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.96, alpha:1.00)
    }
    
    private func setRefreshControl() {
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(TaskTableViewController.loadTasks), for: UIControlEvents.valueChanged)
        tableView.addSubview(self.refreshControl!)
    }
    
    func filterTask(keyword: String) {
        self.filteredTaskList = taskList.filter({ (task) -> Bool in
//            Will Change it to postion later
            if task.title.lowercased().contains(keyword.lowercased()) {
                return true
            } else {
                return false
            }
        })
    }

    @IBAction func addButtonTouched(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddTaskSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if isLoggedIn() {
            setUpSearchBar()
            setUpTableView()
        } else {
            print("User is not logged in")
        }
        setRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoggedIn() {
            loadTasks()
        } else {
            print("User is not logged in")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive {
            return self.filteredTaskList.count
        } else {
            return taskList.count
        }
    }
    
    private func loadTaskToCell(task: Task, taskTableViewCell: TaskTableViewCell) {
        taskTableViewCell.taskTitleLabel.text = task.title
        taskTableViewCell.taskAddressLabel.text = task.address
//        Image view will be done later
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        
        if searchController.isActive {
            loadTaskToCell(task: filteredTaskList[indexPath.row], taskTableViewCell: cell)
        } else {
            loadTaskToCell(task: taskList[indexPath.row], taskTableViewCell: cell)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "TaskDetailSegue", sender: indexPath)
    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskDetailSegue" {
            let taskDetailTableViewController = segue.destination as! TaskDetailTableViewController
            let indexPath = sender as! IndexPath
            if searchController.isActive {
                taskDetailTableViewController.task = self.filteredTaskList[indexPath.row]
            } else {
                taskDetailTableViewController.task = self.taskList[indexPath.row]
            }
        } else if segue.identifier == "AddTaskSegue" {
            let navigationController = segue.destination as! UINavigationController
            let addModifyTaskTableViewController = navigationController.viewControllers.first as! AddModifyTaskTableViewController
            addModifyTaskTableViewController.isAddingTask = true
            addModifyTaskTableViewController.task = nil
        }
    }
}

extension TaskTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let keyword = searchController.searchBar.text {
            self.filterTask(keyword: keyword)
            tableView.reloadData()
        }
    }
}
