//
//  BCModel.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 07/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import Foundation
import CoreLocation
import CloudKit

//Simple singleton model
let globalModel : BCModel = BCModel()

final class BCModel {
   // CloudKit database
   let publicDB = CKContainer.default().publicCloudDatabase
   
   fileprivate let archivePath = pathToFileInDocumentsFolder("locations")
   fileprivate var arrayOfLocations = [CLLocation]()
   fileprivate let queue : DispatchQueue = DispatchQueue(label: "uk.ac.plmouth.bc", attributes: [])
   fileprivate let archiveKey = "LocationArray"
   
   // MARK: Life-cycle
   
    //The constructor is private, so it cannot be instantiated anywhere else
   fileprivate init() {
      //Phase 1 has nothing to do
      
      //Call superclass if you subclass
//      super.init()
      
      //Phase 2 - self is now available
      if let m = NSKeyedUnarchiver.unarchiveObject(withFile: self.archivePath) as? [CLLocation] {
         arrayOfLocations = m
      }
   }
   
   
   // MARK: Public API
   
   // All these methods are serialsed on a background thread. KEY POINT: None can preempt the other.
   // For example, if save is called multiple times, each save operation will complete before the next is allowed to start.
   //
   // Furthermore, if an addRecord is called, but there is a save in front, this could take a significant time.
   // As everthing is queued on a separate thread, there is no risk of blocking the main thread.
   // Each method invokes a closure on the main thread when completed
   
   /// Save the array to persistant storage (simple method) serialised on a background thread
   func save(done : @escaping ()->() )
   {
      //Save on a background thread - note this is a serial queue, so multiple calls to save will be performed
      //in strict sequence (to avoid races)
      queue.async {
         //Persist data to file
         NSKeyedArchiver.archiveRootObject(self.arrayOfLocations, toFile:self.archivePath)
         //Call back on main thread (posted to main runloop)
         DispatchQueue.main.sync(execute: done)
      }
   }
   
   /// Erase all data (serialised on a background thread)
   func erase(done : @escaping ()->() ) {
      queue.async {
         self.arrayOfLocations.removeAll()
         //Call back on main thread (posted to main runloop)
         DispatchQueue.main.sync(execute: done)
      }
   }
   
   /// Add a record (serialised on a background thread)
   func addRecord(_ record : CLLocation, done : @escaping ()->() ) {
      queue.async{
         self.arrayOfLocations.append(record)
         //Call back on main thread (posted to main runloop)
         DispatchQueue.main.sync(execute: done)
      }
   }
   
   /// Add an array of records
   func addRecords(_ records : [CLLocation], done : @escaping ()->() ) {
      queue.async{
         for r in records {
            self.arrayOfLocations.append(r)
         }
         //Call back on main thread (posted to main runloop)
         DispatchQueue.main.sync(execute: done)
      }
   }
   
   /// Thread-safe read access
   func getArray(done : @escaping (_ array : [CLLocation]) -> () ) {
      var copyOfArray : [CLLocation]!
      queue.async{
         //Call back on main thread (posted to main runloop)
         copyOfArray = self.arrayOfLocations
         DispatchQueue.main.sync(execute: { done(copyOfArray) })
      }
   }
   
   /// Query if the container is empty
   func isEmpty(done : @escaping (_ isEmpty : Bool) -> () ) {
      queue.async {
        let result = self.arrayOfLocations.count == 0 ? true : false
         DispatchQueue.main.sync(execute: { done(result) })
      }
   }
   
    
    // MARK: Cloud Kit
    
   /// Upload the array of data to CloudKit
   func uploadToCloudKit(_ done : @escaping (_ didSucceed : Bool)->() ) {
      //Fetch a copy of the array
      getArray() { (array : [CLLocation]) in
         //Back on the main thread
         let record = CKRecord(recordType: "Locations")
         record.setObject("My Only Route" as CKRecordValue?, forKey: "title")
         record.setObject(array as CKRecordValue?, forKey: "route")
         self.publicDB.save(record, completionHandler: { (rec : CKRecord?, err: NSError?) in
            if let _ = err {
               done(false)
            } else {
               done(true)
            }
         } as! (CKRecord?, Error?) -> Void) 
      }
   }
   
   //Delete records from cloudkit
   func deleteDataFromCloudKit(_ done : @escaping (_ didSucceed : Bool)->() ) {
      let p = NSPredicate(format: "title == %@", "My Only Route")
      let query = CKQuery(recordType: "Locations", predicate: p)
      publicDB.perform(query, inZoneWith: nil) { (results : [CKRecord]?, error : NSError?) in
         if let _ = error {
            done(didSucceed: false)
            return
         }
         guard let res = results else {
            done(didSucceed: false)
            return
         }
         for r : CKRecord in res {
            self.publicDB.delete(withRecordID: r.recordID) { r, err in
               if let _ = err {
                  done(didSucceed: false)
                  return
               }
            }
         }
         done(didSucceed: true)
      } as! ([CKRecord]?, Error?) -> Void as! ([CKRecord]?, Error?) -> Void as! ([CKRecord]?, Error?) -> Void as! ([CKRecord]?, Error?) -> Void as! ([CKRecord]?, Error?) -> Void as! ([CKRecord]?, Error?) -> Void as! ([CKRecord]?, Error?) -> Void
   }
   
}
