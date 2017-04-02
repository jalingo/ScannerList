//
//  ScannerListTVC.swift
//  ScannerList
//
//  Created by Jimmy Lingo on 4/2/17.
//  Copyright © 2017 Promethatech. All rights reserved.
//

import UIKit

// MARK: - Typealiases

typealias Entry = (title: String, inCart: Bool, price: NSNumber)

// MARK: - Protocols

protocol ScannerList {
    var entries: [Entry] { get set }
}

protocol ScannerCell {
    func config(for parent: ScannerList, index: Int) -> ScannerCell
}

// MARK: - Class: ScannerListTVC

class ScannerListTVC: UITableViewController, ScannerList {

    // MARK: - Properties

    let defaultEntry: Entry = ("Tap to Edit Text...", false, 0)

    var entries = [Entry]()

    @IBOutlet var addEntryButton: UIButton?
    
    // MARK: - Functions
    
    @IBAction func addEntyPressed(_ sender: UIButton) {
        entries += [defaultEntry]
        self.tableView.reloadData()
    }
}

// MARK: - Extensions

//extension ScannerListTVC { //UIViewController methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

//}

// MARK: - Extension: UITableViewController

extension ScannerListTVC {
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        if indexPath.row > entries.count {
            cell = tableView.dequeueReusableCell(withIdentifier: "totalsCell", for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        }

        let errorCell = tableView.dequeueReusableCell(withIdentifier: "errorCell", for: indexPath)
        if let scannerCell = cell as? ScannerCell {
            return scannerCell.config(for: self, index: indexPath.row) as? UITableViewCell ?? errorCell
        } else {
            return errorCell
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let entry = entries[fromIndexPath.row]
        entries.remove(at: fromIndexPath.row)
        entries.insert(entry, at: to.row)
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
}
