//
//  BCOptions.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 25/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

struct BCOptions {
    
    static let defaultsDictionary : [String : AnyObject] = {
        let fp = Bundle.main.path(forResource: "factoryDefaults", ofType: "plist")
        return NSDictionary(contentsOfFile: fp!) as! [String : AnyObject]
    }()
    
    static let defaults : UserDefaults = {
        let ud = UserDefaults.standard
        ud.register(defaults: BCOptions.defaultsDictionary)
        ud.synchronize()
        return ud
    }()
    
    lazy var backgroundUpdates : Bool = BCOptions.defaults.bool(forKey: "backgroundUpdates")
    lazy var headingAvailable : Bool  = CLLocationManager.headingAvailable()
    lazy var headingUP : Bool         = {
        return self.headingAvailable && BCOptions.defaults.bool(forKey: "headingUP")
    }()
    var userTrackingMode : MKUserTrackingMode {
        mutating get {
            return self.headingUP ? .followWithHeading : .follow
        }
    }
    lazy var showTraffic : Bool = BCOptions.defaults.bool(forKey: "showTraffic")
    lazy var distanceBetweenMeasurements : Double = BCOptions.defaults.double(forKey: "distanceBetweekMeasurements")
    lazy var gpsPrecision : Double = BCOptions.defaults.double(forKey: "gpsPrecision")
    
    mutating func updateDefaults() {
        BCOptions.defaults.set(backgroundUpdates, forKey: "backgroundUpdates")
        BCOptions.defaults.set(headingUP, forKey: "headingUP")
        BCOptions.defaults.set(showTraffic, forKey: "showTraffic")
        BCOptions.defaults.set(distanceBetweenMeasurements, forKey: "distanceBetweenMeasurements")
        BCOptions.defaults.set(gpsPrecision, forKey: "gpsPrecision")
    }
    
    static func commit() {
        BCOptions.defaults.synchronize()
    }
}
