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

    var entry: Entry?
    
    var entryIndex: Int?
    
    @IBOutlet weak var priceField: UITextField!
    
    // MARK: - Functions
    
    @IBAction func priceFieldEdited(_ sender: UITextField) {
        guard sender.text != nil else { return }
        
        if let price = Double(sender.text!) {
            entry?.price = NSNumber(value: price)
        }
    }
    
    @IBAction func acceptPressed(_ sender: UIButton) {
        entry?.inCart = true
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addToolBarToFieldKeyboard(textField: priceField)
        
        if let price = entry?.price.doubleValue {
            priceField.text = "\(round(price * 100) / 100)"
        }
    }

    // Returns new price to Scanner List's 'entries'
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
print("checking entry: \(String(describing: entry)) & index: \(String(describing: entryIndex))")
        guard entry != nil, entryIndex != nil else { return }
print("preparing segue @ PriceInput")
        if var controller = segue.destination as? ScannerList {
print("seguing to ScannerList")
            controller.entries[entryIndex!] = entry!
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
