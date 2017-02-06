//
//  BCOptions.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 04/12/2015.
//  Copyright © 2015 Plymouth University. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

/// A structure that encapsualtes the functionality for passing, updating and persisting the options for the Bread Crumbs app
/// - note: If there are two copies, it is not clear if races can occur when writing userdefaults with `updateDefaults()`. It is reccomended you only call `updateDefaults()` on one copy OR if you do, call `commit()` immediately after.
/// - author: Nicholas Outram, Plymouth University
/// - version: 1.0

struct BCOptions {
   
   //This structure uses NSUserDefaults - designed to store a heirarchy of Foundation Class objects (NSNumber in this case)
   //Swift types Bool and Float will be bridged automatically to Foundation class types
   
   /// Factory defaults - if no user default is set, these will be used
   /// Read key-value pairs from a plist file
   static let defaultsDictionary : [String : AnyObject] = {
      let fp = Bundle.main.path(forResource: "factoryDefaults", ofType: "plist")
      return NSDictionary(contentsOfFile: fp!) as! [String : AnyObject]
   }()
   
   ///Access the standardUserDefaults via this property to ensure factory settings (registration domain) are initialised.
   ///In the event that no userdefaults have been set yet, it will fall back the factory default.
   static let defaults : UserDefaults = {
      //Initiaised lazily (in part because it is static) using a closure.
      let ud = UserDefaults.standard
      ud.register(defaults: BCOptions.defaultsDictionary)
      ud.synchronize()
      return ud
   }() // Note the parenthesis on the end
    
   
   // Public properties - these are value-type variable backed, so independent copies can be made
   // These parameters are NOT static and are storage backed. 
   // I want to exploit the value-type semantics as I pass this forward through the navigation stack
   // They are all initalised using the userdefaults
   
   /// determines if the GPS will continue to log data when the app is running in the background. Has an impact on battery drain.
   lazy var backgroundUpdates : Bool            = BCOptions.defaults.bool(forKey: "backgroundUpdates")
   /// Read only property to determine if heading data is available from the device
   lazy var headingAvailable : Bool             = CLLocationManager.headingAvailable()
   /// determines if the map is rotated so the heading is always towards the top of the screen
   lazy var headingUP : Bool                    = {
      //Note - user defaults are backed up, so can end up in an invalid state if restored on an older device
      return CLLocationManager.headingAvailable() && BCOptions.defaults.bool(forKey: "headingUP")
   }()
   /// Computed property to return the user tracking mode - mutating is there becase this can cause `headingUp` to mutate
   var userTrackingMode : MKUserTrackingMode {
      mutating get {
         return headingUP ? .followWithHeading : .follow
      }
   }
   /// determines if the traffic is shown on the map
   lazy var showTraffic : Bool                  = BCOptions.defaults.bool(forKey: "showTraffic")
   /// distance (in meters) you must travel before another GPS location is reported. A higher value may results in extended battery time
   lazy var distanceBetweenMeasurements : Double = BCOptions.defaults.double(forKey: "distanceBetweenMeasurements")
   /// requried prevision of the GPS (in meters). Higher values are less specific, but are faster to obtain and may require less battery
   lazy var gpsPrecision : Double                = BCOptions.defaults.double(forKey: "gpsPrecision")

   /// Save the current record set to userdefaults (note - userdefaults may be cached, so call commit before allowing the application to close)
   mutating func updateDefaults() {
      BCOptions.defaults.set(backgroundUpdates, forKey: "backgroundUpdates")
      BCOptions.defaults.set(headingUP, forKey: "headingUP")
      BCOptions.defaults.set(showTraffic, forKey: "showTraffic")
      BCOptions.defaults.set(distanceBetweenMeasurements, forKey: "distanceBetweenMeasurements")
      BCOptions.defaults.set(gpsPrecision, forKey: "gpsPrecision")
   }
   
   /// Given that userdefaults are cached and only saved periodically, calling this forces them to be saved
   static func commit() {
      BCOptions.defaults.synchronize()
   }
   
}
