//
//  UploadEntries.swift
//  ScannerList
//
//  Created by Jimmy Lingo on 5/6/17.
//  Copyright © 2017 Promethatech. All rights reserved.
//

import CloudKit

class UploadRecordable: Operation {
    
    // MARK: - Properties
    
    fileprivate let entries: [RecordableEntry]
    
    fileprivate var recordsFetched = [CKRecord]()
    
    fileprivate var entriesAsRecordIDs: [CKRecordID] {
        return entries.map() { $0.recordID }
    }
    
    fileprivate var database = CKContainer.default().privateCloudDatabase
    
    fileprivate var savedForAsyncCompletion: OptionalClosure
    
    override var completionBlock: (() -> Void)? {
        get { return nil }                              // <-- This ensures completionBlock doesn't execute prematurely...
        set { savedForAsyncCompletion = newValue }
    }
    
    // MARK: - Functions
    
    fileprivate func completeListOfRecords(withTheseDiscovered: [CKRecord]) -> [CKRecord] {
        var records = withTheseDiscovered
        let ids = withTheseDiscovered.map() { $0.recordID }
        
        for entry in entries where !ids.contains(entry.recordID) {
            let record = CKRecord(recordType: entry.recordType, recordID: entry.recordID)
            records.append(record)
        }
        
        return records
    }
    
    fileprivate func matchValues(from: [Recordable], to: [CKRecord]) -> [CKRecord]? {
        guard from.count == to.count else { return nil }
        
        var records = [CKRecord]()
        
        for recordable in from {
            var record: CKRecord
            
            // Prepares fetched record, or creates a new one...
            if let indexOfRecord = to.index(where: { $0.recordID == recordable.recordID }) {
                record = to[indexOfRecord]
            } else {
                record = CKRecord(recordType: recordable.recordType, recordID: recordable.recordID)
            }
            
            // Matches values to record...
            for entry in recordable.recordFields {
                record[entry.key] = entry.value
            }
            
            records.append(record)
        }
        
        return records
    }
    
    fileprivate func handle(_ error: Error?, from op: CKOperation, whileIgnoringUnknownItem: Bool) {
        
        if isCancelled { return }
        
        if let cloudError = error as? CKError {
            print("handling error @ UploadEntries")
            let errorHandler = CKErrorHandler(error: cloudError,
                                              originating: op,
                                              instances: self.entries,
                                              target: self.database)
            errorHandler.ignoreUnknownItem = whileIgnoringUnknownItem
            ErrorQueue().addOperation(errorHandler)
        } else {
            print("NSError: \(String(describing: error?.localizedDescription)) @ UploadEntries::\(op)")
        }
    }
    
    // MARK: - Functions: Operation

    override func main() {
        if isCancelled { return }
        
        let fetchOp = CKFetchRecordsOperation(recordIDs: entriesAsRecordIDs)
        fetchOp.perRecordCompletionBlock = { [weak me = self] record, id, error in
            guard me != nil else { print("weak me failed @ UploadEntries.main.0"); return }
            
            if error != nil {   // <-- Using if, NOT guard, to allow for ignoring UnknownItem...
                me?.handle(error, from: fetchOp, whileIgnoringUnknownItem: true)
            }
            
            if let fetchedRecord = record { me?.recordsFetched.append(fetchedRecord) }
        }
        
        fetchOp.fetchRecordsCompletionBlock = { [weak me = self] results, error in
            guard me != nil else { print("weak me failed @ UploadEntries.main.1"); return }

            if error != nil {   // <-- Using if, NOT guard, to allow for ignoring UnknownItem...
                me?.handle(error, from: fetchOp, whileIgnoringUnknownItem: true)
            }
            
            if let recordsToModify = me!.matchValues(from: me!.entries,
                                                     to: me!.completeListOfRecords(withTheseDiscovered: me!.recordsFetched)) {
                let modifyOp = CKModifyRecordsOperation(recordsToSave: recordsToModify,
                                                        recordIDsToDelete: nil)
                modifyOp.isLongLived = true
                
                // This transfers `UploadEntries.completionBlock` to the end of modify operation...
                modifyOp.completionBlock = me!.savedForAsyncCompletion
                
                modifyOp.modifyRecordsCompletionBlock = { [weak me = self] records, ids, error in
                    guard me != nil else { print("weak me failed @ UploadEntries.main.2"); return }

                    guard error == nil else {
                        me!.handle(error, from: modifyOp, whileIgnoringUnknownItem: false)
                        return
                    }
                }
                
                if self.isCancelled { return }
                me!.database.add(modifyOp)
            } else {
                print("Fail @ UploadEntries")
            }
        }
        
        if isCancelled { return }
        database.add(fetchOp)
    }
    
    fileprivate override init() { entries = [RecordableEntry(list: "Dummy List")] }
    
    init(_ array: [RecordableEntry], target: CKDatabase? = nil) {
        entries = array
        if let db = target { database = db }
        
        super.init()
    }
}
