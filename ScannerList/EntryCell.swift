//
//  EntryCell.swift
//  ScannerList
//
//  Created by Jimmy Lingo on 4/2/17.
//  Copyright © 2017 Promethatech. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {

    // MARK: - Properties
    
    fileprivate var parent: ScannerList?
    
    fileprivate var currentEntry: Entry?
    
    @IBOutlet weak var entryTitle: UITextField!
    
    @IBOutlet weak var checkmarkButton: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - Functions

    @IBAction func entryTitleEdited(_ sender: UITextField) {
        guard currentEntry != nil else { return }
        
        if let index = parent?.entries.index(where: { $0 == currentEntry! }) {
            if let text = entryTitle.text {
                parent?.entries.remove(at: index)
                currentEntry?.title = text
                parent?.entries.insert(currentEntry!, at: index)
            }
        }
    }
    
    @IBAction func checkmarkPressed(_ sender: UIButton) {
        guard currentEntry != nil else { return }
        
        if let index = parent?.entries.index(where: { $0 == currentEntry! }) {
            parent?.entries.remove(at: index)
            currentEntry!.inCart = !currentEntry!.inCart
            parent?.entries.insert(currentEntry!, at: index)
            parent?.selectedIndex = index
        }
    }
}

// MARK: - Extension: ScannerCell

extension EntryCell: ScannerCell {
    
    func config(for list: ScannerList, index: Int) -> ScannerCell {
        let entry = list.entries[index]

        self.currentEntry = entry
        self.entryTitle.text = entry.title
        self.checkmarkButton.isSelected = entry.inCart
        self.priceLabel.text = "$\(entry.price)"
        
        return self
    }
}
