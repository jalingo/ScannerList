//
//  RecordableEntry.swift
//  ScannerList
//
//  Created by Jimmy Lingo on 5/6/17.
//  Copyright © 2017 Promethatech. All rights reserved.
//

import CloudKit

// MARK: - Global Vars

let ENTRY_REC_TYPE   = "ListEntry"
let ENTRY_TITLE_KEY  = "EntryTitle"
let ENTRY_CARTED_KEY = "EntryInCart"
let ENTRY_PRICE_KEY  = "EntryPrice"
let ENTRY_LIST_KEY   = "EntryListTitle"

// MARK: - Struct

struct RecordableEntry {
    
    // MARK: - Properties
    
    var title = defaultEntry.title
    
    var inCart = defaultEntry.inCart
    
    var price = defaultEntry.price
    
    var list: String
    
    // MARK: - Properties: Recordable
    
    /**
     * A record identifier used to store and recover conforming instance's record. This ID is
     * used to construct records and references, as well as query and fetch from the cloud
     * database.
     *
     * - Warning: Must be unique in the database.
     */
    var recordID: CKRecordID
    
    // MARK: - Functions
    
    init(list listTitle: String) {
        list = listTitle
        recordID = CKRecordID(recordName: "\(title) in \(listTitle)")
    }
}

// MARK: - Extension: Recordable

extension RecordableEntry: Recordable {
    
    // MARK: - Properties
    
    /**
     * This is a token used with cloudkit to build CKRecordID for this object's CKRecord.
     */
    var recordType: String { return ENTRY_REC_TYPE }
    
    /**
     * This dictionary has to match all of the keys used in CKRecord in order for version
     * conflicts and retry attempts to succeed. Its values should match the associated
     * fields in CKRecord.
     */
    var recordFields: Dictionary<String, CKRecordValue> {
        
        get {
            var dictionary = Dictionary<String, CKRecordValue>()
            
            dictionary[ENTRY_TITLE_KEY]  = title as CKRecordValue
            dictionary[ENTRY_CARTED_KEY] = inCart as NSNumber
            dictionary[ENTRY_PRICE_KEY]  = price as CKRecordValue
            dictionary[ENTRY_LIST_KEY]   = list as CKRecordValue
            
            return dictionary
        }
        
        set {
            if let str = newValue[ENTRY_TITLE_KEY]  as? NSString { title = str as String }
            if let num = newValue[ENTRY_CARTED_KEY] as? NSNumber { inCart = num.boolValue }
            if let num = newValue[ENTRY_PRICE_KEY]  as? NSNumber { price = num }
            if let str = newValue[ENTRY_LIST_KEY]   as? NSString { list = str as String }
        }
    }
}
