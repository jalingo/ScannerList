//
//  ScannerListTVC.swift
//  ScannerList
//
//  Created by Jimmy Lingo on 4/2/17.
//  Copyright © 2017 Promethatech. All rights reserved.
//

import UIKit

let defaultEntry: Entry = ("Tap to Edit Text...", false, 0)

// MARK: - Typealiases

typealias Entry = (title: String, inCart: Bool, price: NSNumber)

// MARK: - Protocols

protocol ScannerList {
    var listTitle: String?  { get set }
    var entries: [Entry]    { get set }
    var selectedIndex: Int? { get set }
}

protocol ScannerCell {
    func config(for parent: ScannerList, index: Int) -> ScannerCell
}

// MARK: - Class: ScannerListTVC

class ScannerListTVC: UITableViewController, ScannerList {

    // MARK: - Properties
    
    var listTitle: String?
    
    var selectedIndex: Int?

    //setup data model
    var entries = [defaultEntry] {
        didSet { self.tableView.reloadData() }
    }

    @IBOutlet var addEntryButton: UIButton?
    
    // MARK: - Functions
    
    @IBAction func addEntryPressed(_ sender: UIButton) {
        entries += [defaultEntry]
    }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .bookmarks,
//                                             target: self,
//                                             action: #selector(ScannerListTVC.rightBarButtonPressed))

//        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
//    func rightBarButtonPressed() {
//        let listHistory = ListHistoryTVC()
//print("preparing")
//        if let index = listHistory.lists.index(where: { $0 == listTitle }) {
//print("removing")
//            listHistory.lists.remove(at: index)
//print("adding")
//            listHistory.lists.insert(listTitle!, at: index)
//        } else {
//print("else")
//            listHistory.lists.append("untitled list")
//        }
//        
//        self.navigationController?.pushViewController(listHistory, animated: true)
//    }
    
    // Should not be queried when 'rightBarButtonPressed' triggers manual push...
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool {
        guard identifier != "listToHistory" else { return true }
        guard selectedIndex != nil else { return false }
        
        // This seems to return the opposite, but value is changed before method called.
        return entries[selectedIndex!].inCart
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PriceInputView {
            controller.parentDelegate = self
        }
        
        if var controller = segue.destination as? ListHistory {
            if let str = listTitle,
                let index = controller.lists.index(where: { $0 == str }) {
                    
                controller.lists.remove(at: index)
                controller.lists.insert(str, at: index)
            } else {
                controller.lists.append("untitled")
            }
        }
    }
}

// MARK: - Extensions

// MARK: - Extension: UITableViewController

extension ScannerListTVC {
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return entries.count + 1
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        if indexPath.row >= entries.count {
            cell = tableView.dequeueReusableCell(withIdentifier: "totalsCell", for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        }

        if let scannerCell = cell as? ScannerCell {
            return scannerCell.config(for: self, index: indexPath.row) as? UITableViewCell ?? error(for: indexPath)
        } else {
            return error(for: indexPath)
        }
    }
    
    fileprivate func error(for path: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "errorCell", for: path)
    }
    
    override func tableView(_ tableView: UITableView,
                            canMoveRowAt indexPath: IndexPath) -> Bool {
        return entries.count != indexPath.row ? true : false
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let entry = entries[fromIndexPath.row]
        entries.remove(at: fromIndexPath.row)
        entries.insert(entry, at: to.row)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        return entries.count != indexPath.row ? true : false
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { entries.remove(at: indexPath.row) }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return entries.count != indexPath.row ? .delete : .none
    }
}







