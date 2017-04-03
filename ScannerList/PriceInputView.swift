//
//  PriceInputView.swift
//  ScannerList
//
//  Created by Jimmy Lingo on 4/2/17.
//  Copyright © 2017 Promethatech. All rights reserved.
//

import UIKit

class PriceInputView: UIViewController {

    // MARK: - Properties

    var parentDelegate: ScannerList?
    
    var entry: Entry? {
        get {
            if let index = entryIndex {
                return parentDelegate?.entries[index]
            } else {
                return nil
            }
        }
        
        set {
            guard newValue != nil else { return }

            if let index = entryIndex {
                parentDelegate?.entries[index] = newValue!
            }
        }
    }
    
    var entryIndex: Int? {
        return parentDelegate?.selectedIndex
    }
    
    @IBOutlet weak var priceField: UITextField!
    
    // MARK: - Functions
    
    @IBAction func priceFieldEdited(_ sender: UITextField) {
        guard sender.text != nil else { return }
        
        if let price = Double(sender.text!) {
            entry?.price = NSNumber(value: price)
        }
    }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addToolBarToFieldKeyboard(textField: priceField)
        
        if let price = entry?.price.doubleValue {
            priceField.text = "\(round(price * 100) / 100)"
        }
    }
}

// MARK: - Extensions

// MARK: - Extensions: UITextFieldDelegate

extension PriceInputView: UITextFieldDelegate {
    
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
        self.view.endEditing(true)
    }
}
