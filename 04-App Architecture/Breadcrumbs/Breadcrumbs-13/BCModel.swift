//
//  BCModel.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 25/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import Foundation
import CoreLocation

let globalModel : BCModel = BCModel()

final class BCModel {
    
    fileprivate var arrayOfLocations = [CLLocation]()
    fileprivate let archivePath = pathToFileInDocumentsFolder("locations")
    fileprivate let archiveKey = "LocationArray"
    
    fileprivate let queue : DispatchQueue = DispatchQueue(label: "uk.ac.plymouth.bc", attributes: [])
    
    fileprivate init() {
        //Phase 1 init - nothing to do!

        //super.init()
        
        //Phase 2
        if let m = NSKeyedUnarchiver.unarchiveObject(withFile: self.archivePath) as? [CLLocation] {
            arrayOfLocations = m
        }

    }
    
    //Asynchronous API
    func addRecord(_ record: CLLocation, done: @escaping ()->()) {
        queue.async {
            self.arrayOfLocations.append(record)
            DispatchQueue.main.sync(execute: done)
        }
    }
    
    /// Add an array of records
    // A Swift array of immutable references is also thread safe
    func addRecords(_ records : [CLLocation], done : @escaping ()->() ) {
        queue.async{
            for r in records {
                self.arrayOfLocations.append(r)
            }
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

    // get array
    func getArray(done : @escaping (_ array : [CLLocation]) -> () ) {
        queue.async {
            let copyOfArray = self.arrayOfLocations
            DispatchQueue.main.sync {
                done(copyOfArray)
            }
        }
    }
    
    /// Save the array to persistant storage (simple method) serialised on a background thread
    func save(done : @escaping ()->() ) {
        queue.async {
            NSKeyedArchiver.archiveRootObject(self.arrayOfLocations, toFile: self.archivePath)
            //Call back on main thread (posted to main runloop)
            DispatchQueue.main.sync(execute: done)
        }
    }
    
    func isEmpty(done : @escaping (_ isEmpty : Bool) ->() ) {
        queue.async {
            let result = self.arrayOfLocations.count == 0
            DispatchQueue.main.sync {
                done(result)
            }
        }
    }
    
    
}
