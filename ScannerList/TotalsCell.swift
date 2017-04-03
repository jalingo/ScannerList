//
//  TotalsCell.swift
//  ScannerList
//
//  Created by Jimmy Lingo on 4/2/17.
//  Copyright © 2017 Promethatech. All rights reserved.
//

import UIKit

class TotalsCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet weak var cartRatio: UILabel!
    
    @IBOutlet weak var totalPrice: UILabel!
    
}

extension TotalsCell: ScannerCell {
    
    func config(for parent: ScannerList, index: Int) -> ScannerCell {

        totalPrice.text = totalPrice(of: parent)
        cartRatio.text  = ratio(from: parent)
        
        return self
    }
    
    fileprivate func totalPrice(of list: ScannerList) -> String {
    
        var total: Float = 0
        for entry in list.entries where entry.inCart {
            total += entry.price.floatValue
        }
    
        return "$\(round(total * 1000) / 1000)" //<-- rounds to two decimal places
    }
    
    fileprivate func ratio(from list: ScannerList) -> String {
        
        var totalInCart = 0
        for entry in list.entries where entry.inCart {
            totalInCart += 1
        }
        
        return "\(totalInCart)/\(list.entries.count)"
    }
}
