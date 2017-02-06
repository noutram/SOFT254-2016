//
//  ViewController.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 20/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    /// The application state - "where we are in a known sequence"
    enum AppState {
        case waitingForViewDidLoad
        case requestingAuth
        case liveMapNoLogging
        case liveMapLogging
        
        init() {
            self = .waitingForViewDidLoad
        }
        
    }
    
    /// The type of input (and its value) applied to the state machine
    enum AppStateInputSource {
        case none
        case start
        case authorisationStatus(Bool)
        case userWantsToStart(Bool)
    }
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var optionsButton: UIBarButtonItem!

    // MARK: - Properties
    lazy var locationManager : CLLocationManager = {

        let loc = CLLocationManager()
        
        //Set up location manager with defaults
        loc.desiredAccuracy = kCLLocationAccuracyBest
        loc.distanceFilter = kCLDistanceFilterNone
        loc.delegate = self
        
        //Optimisation of battery
        loc.pausesLocationUpdatesAutomatically = true
        loc.activityType = CLActivityType.fitness
        loc.allowsBackgroundLocationUpdates = false
        
        return loc
    }()
    
    //Applicaion state
    fileprivate var state : AppState = AppState() {
        willSet {
            print("Changing from state \(state) to \(newValue)")
        }
        didSet {
            self.updateOutputWithState()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.updateStateWithInput(.start)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedAlways {
            self.updateStateWithInput(.authorisationStatus(true))
        } else {
            self.updateStateWithInput(.authorisationStatus(false))
        }
    }
    
    // MARK: Action and Events
    @IBAction func doStart(_ sender: AnyObject) {
        self.updateStateWithInput(.userWantsToStart(true))
    }
    
    @IBAction func doStop(_ sender: AnyObject) {
        self.updateStateWithInput(.userWantsToStart(false))
    }
    
    @IBAction func doClear(_ sender: AnyObject) {
        
    }
    
    @IBAction func doOptions(_ sender: AnyObject) {
        
    }
    
    // MARK: State Machine
    //UPDATE STATE
    func updateStateWithInput(_ ip : AppStateInputSource)
    {
        var nextState = self.state
        
        switch (self.state) {
        case .waitingForViewDidLoad:
            if case .start = ip {
                nextState = .requestingAuth
            }
            
        case .requestingAuth:
            if case .authorisationStatus(let val) = ip, val == true {
                nextState = .liveMapNoLogging
            }

        case .liveMapNoLogging:
            
            //Check for user cancelling permission
            if case .authorisationStatus(let val) = ip, val == false {
                nextState = .requestingAuth
            }
            
            //Check for start button
            else if case .userWantsToStart(let val) = ip, val == true {
                nextState = .liveMapLogging
            }
            
        case .liveMapLogging:
            
            //Check for user cancelling permission
            if case .authorisationStatus(let val) = ip, val == false {
                nextState = .requestingAuth
            }
            
            //Check for stop button
            else if case .userWantsToStart(let val) = ip, val == false {
                nextState = .liveMapNoLogging
            }
        }
        
        self.state = nextState
    }
    
    //UPDATE (MOORE) OUTPUTS
    func updateOutputWithState() {
        
        switch (self.state) {
        case .waitingForViewDidLoad:
            break
            
        case .requestingAuth:
            locationManager.requestAlwaysAuthorization()
            
            //Set UI into default state until authorised
            
            //Buttons
            startButton.isEnabled   = false
            stopButton.isEnabled    = false
            clearButton.isEnabled   = false
            optionsButton.isEnabled = false
            
            //Map defaults (pedantic)
            mapView.delegate = nil
            mapView.showsUserLocation = false
            
            //Location manger (pedantic)
            locationManager.stopUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = false
            
        case .liveMapNoLogging:
            
            //Buttons for logging
            startButton.isEnabled = true
            stopButton.isEnabled = false
            optionsButton.isEnabled = false
            
            //Live Map
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
            mapView.showsTraffic = true
            mapView.delegate = self
            
        case .liveMapLogging:
            //Buttons
            startButton.isEnabled   = false
            stopButton.isEnabled    = true
            optionsButton.isEnabled = true
            
            //Map
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
            mapView.showsTraffic = true
            mapView.delegate = self
            
        }
    }

}

