//
//  ListHistoryTVC.swift
//  ScannerList
//
//  Created by Jimmy Lingo on 4/3/17.
//  Copyright © 2017 Promethatech. All rights reserved.
//

import UIKit

protocol ListHistory {
    
    var lists: [String] { get set }
}

class ListHistoryTVC: UITableViewController, ListHistory {

    // MARK: - Properties
    
    fileprivate var selectedIndex: Int?

    var lists = [String]() {
        didSet { self.tableView.reloadData() }
    }
    
    fileprivate var editingEnabled = false {
        didSet { self.tableView.reloadData() }
    }
    
    // MARK: - Functions

    @objc fileprivate func editButtonTapped() { editingEnabled = !editingEnabled }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.editButtonItem.action = #selector(self.editButtonTapped)
    }

    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool {
        return !editingEnabled
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
print("preparing")
        
        if var controller = segue.destination as? ScannerList,
            let index = selectedIndex {
            controller.listTitle = lists[index]
        }
    }
    
    // MARK: - Functions: UITableViewController
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        
        cell.detailTextLabel?.text = lists[indexPath.row]

        editingEnabled ?
            (cell.textLabel?.text = "Edit:") : (cell.textLabel?.text = "")

        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        return editingEnabled
    }

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
}
