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

        if let index = parent?.entries.index(where: { $0.title == currentEntry!.title }) {
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
        self.parent = list

        self.currentEntry = entry
        self.entryTitle.text = entry.title
        self.checkmarkButton.isSelected = entry.inCart
        self.priceLabel.text = "$\(round(entry.price.doubleValue * 1000) / 1000)"
        
        addToolBarToFieldKeyboard(textField: entryTitle)
        
        return self
    }
}

// MARK: - Extensions: UITextFieldDelegate

extension EntryCell: UITextFieldDelegate {
    
    // MARK: - Functions
    
    func addToolBarToFieldKeyboard(textField: UITextField) {
        
        textField.delegate = self
        textField.inputAccessoryView = buildToolBar()
    }
    
    func buildToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donePressed))
        toolBar.setItems([space, doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        return toolBar
    }
    
    func donePressed() {
        self.contentView.endEditing(true)
    }
}

