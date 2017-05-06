//
//  DataService.swift
//  ScannerList
//
//  Created by Jimmy Lingo on 4/11/17.
//  Copyright © 2017 Promethatech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// MARK: - Global Constants

let DATABASE_URL_WITH_KEY = "http://api.upcdatabase.org/json/c1a2b838e626670daa281eb5ce59bc16/"

struct DataService {
    
    static let dataService = DataService()
    
    private(set) var NAME_FROM_DATABASE = ""
    private(set) var PRICE_FROM_DATABASE = ""
    
    static func searchAPI(codeNumber: String) {
    
        let requestURL = "\(DATABASE_URL_WITH_KEY)\(codeNumber)"

        Alamofire.request(requestURL).responseJSON { response in
            
            if let resultJSON = response.result.value {
                print("JSON: \(resultJSON)")                
            }
        }
    }
}
