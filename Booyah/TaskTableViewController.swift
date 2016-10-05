//
//  TaskTableViewController.swift
//  Booyah
//
//  Created by Paul Zhang on 4/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    var taskList = [Task]()
    
    var filteredTaskList = [Task]()
    
    var searchController: UISearchController!
    
    private func loadTasks() {
        taskList += [
            Task(title: "Task 1", description: "", date: Date(), userId: "", address: "Sydney", latitude: 0.0, longitude: 0.0),
            Task(title: "Task 2", description: "", date: Date(), userId: "", address: "Melbourne", latitude: 0.0, longitude: 0.0),
            Task(title: "Task 3", description: "", date: Date(), userId: "", address: "Adelaide", latitude: 0.0, longitude: 0.0),
        ]
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
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadTasks()
        setUpSearchBar()
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        
        if searchController.isActive {
            cell.textLabel?.text = filteredTaskList[indexPath.row].title
        } else {
            cell.textLabel?.text = taskList[indexPath.row].title
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TaskDetailSegue", sender: indexPath)
//        tableView.deselectRow(at: indexPath, animated: true)
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "TaskDetailSegue" {
//            self.searchController.isActive = false
            let taskDetailTableViewController = segue.destination as! TaskDetailTableViewController
            let indexPath = sender as! IndexPath
            taskDetailTableViewController.task = self.taskList[indexPath.row]
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
