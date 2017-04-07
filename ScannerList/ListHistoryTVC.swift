//
//  ListHistoryTVC.swift
//  ScannerList
//
//  Created by Jimmy Lingo on 4/3/17.
//  Copyright © 2017 Promethatech. All rights reserved.
//

import UIKit

// MARK: - Protocols

protocol ListHistory {
    var lists: [String] { get set }
}

// MARK: - Class

class ListHistoryTVC: UITableViewController, ListHistory {

    // MARK: - Properties
    
    fileprivate var selectedIndex: Int?

    var lists = [String]() {
        didSet {
            lists.count != 0 ?
                self.tableView.reloadData() : resetLists()
        }
    }
    
    fileprivate var editingEnabled = false {
        didSet { self.tableView.reloadData() }
    }
    
    // MARK: - Functions

    fileprivate func resetLists() {
        guard lists.count == 0 else { return }

        lists.append("My First List")
        self.navigationController?.setEditing(false, animated: true)
        editingEnabled = false
    }
    
    @objc fileprivate func editButtonTapped() {
        editingEnabled = !editingEnabled
    }
    
    deinit {
        print("ListHistoryTVC deallocated :)")
    }
}

// MARK: - Extensions

// MARK: - Extension: UIViewController

extension ListHistoryTVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.editButtonItem.action = #selector(self.editButtonTapped)
        resetLists()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool {
        return !editingEnabled
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var controller = segue.destination as? ScannerList,
            let index = selectedIndex {
            controller.listTitle = lists[index]
        }
    }
}

// MARK: - Extension: UITableViewController (Delegate / Data)

extension ListHistoryTVC {
    
    // MARK: - Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "listCell",
                                                      for: indexPath)
        
        cell.detailTextLabel?.text = lists[indexPath.row]
        
        editingEnabled ?
            (cell.textLabel?.text = "Edit:") : (cell.textLabel?.text = "")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        editingEnabled ?
            renameListWithAlert() : performSegue(withIdentifier: "historyToListDetail",
                                                 sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func renameListWithAlert() {
        guard selectedIndex != nil else { return }
        
        let alertController = UIAlertController(title: "Rename: \(lists[selectedIndex!])",
            message: nil,
            preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "Change", style: .default) { [weak self] action in
            if let me = self {
                let textField = alertController.textFields![0] as UITextField
                me.lists[me.selectedIndex!] = textField.text!
            }
        }
        
        okay.isEnabled = false  // <-- Enabled after text has been entered.
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        alertController.addTextField { [weak self] textField in
            if let me = self {
                textField.placeholder = me.lists[me.selectedIndex!]
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange,
                                                       object: textField,
                                                       queue: OperationQueue.main) { notification in
                    okay.isEnabled = textField.text != ""   // <-- Conditional expression true if valid text input exists
                }
            }
        }
        
        alertController.addAction(okay)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return editingEnabled
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return !editingEnabled
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            lists.remove(at: indexPath.row)
        } else if editingStyle == .insert {
            print("insert attempted")
        }
    }
}
