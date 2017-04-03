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
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let price = entry?.price.doubleValue {
            priceField.text = "\(round(price * 100) / 100)"
        }
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    // Returns new price to Scanner List's 'entries'
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard entry != nil, entryIndex != nil else { return }
        
        if var controller = segue.destination as? ScannerList {
            controller.entries[entryIndex!].price = entry!.price
        }
    }

}
