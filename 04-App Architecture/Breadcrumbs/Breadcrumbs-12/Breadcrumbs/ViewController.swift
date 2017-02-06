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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, BCOptionsSheetDelegate {
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
    
    fileprivate var options : BCOptions = BCOptions() {
        didSet {
            options.updateDefaults()
            BCOptions.commit()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _ = locations.last else {return}
        
        globalModel.addRecords(locations) {
            self.updateMapOverlay()
        }
    }
    
    func updateMapOverlay() {
        globalModel.getArray() { (array : [CLLocation]) in
            var arrayOfCoords = array.map() {
                $0.coordinate
            }
            let line = MKPolyline(coordinates: &arrayOfCoords, count: arrayOfCoords.count)
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.add(line)
        }
    }
    
    // MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let path = MKPolylineRenderer(overlay: overlay)
        path.strokeColor = UIColor.purple
        path.lineWidth = 2.0
        path.lineDashPattern = [10, 4]
        return path
    }
    
    // MARK: Action and Events
    @IBAction func doStart(_ sender: AnyObject) {
        self.updateStateWithInput(.userWantsToStart(true))
    }
    
    @IBAction func doStop(_ sender: AnyObject) {
        self.updateStateWithInput(.userWantsToStart(false))
        globalModel.save() {
            
        }
    }
    
    @IBAction func doClear(_ sender: AnyObject) {
        globalModel.erase() {
            globalModel.save() {
                self.updateStateWithInput(.none)
                self.updateMapOverlay()
            }
        }
    }
    
    @IBAction func doOptions(_ sender: AnyObject) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalOptions" {
            if let dstVC = segue.destination as? BCOptionsTableViewController {
                dstVC.delegate = self
            }
        }
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
            optionsButton.isEnabled = true
            globalModel.isEmpty() { (empty : Bool) -> () in
                self.clearButton.isEnabled = !empty
            }
            
            //Live Map
            mapView.showsUserLocation = true
            mapView.userTrackingMode = self.options.userTrackingMode
            mapView.showsTraffic = self.options.showTraffic
            mapView.delegate = self
            
            //Location Manager
            locationManager.desiredAccuracy = self.options.gpsPrecision
            locationManager.distanceFilter  = self.options.distanceBetweenMeasurements
            locationManager.allowsBackgroundLocationUpdates = self.options.backgroundUpdates
            locationManager.stopUpdatingLocation()
            locationManager.stopUpdatingHeading()
            
        case .liveMapLogging:
            //Buttons
            startButton.isEnabled   = false
            stopButton.isEnabled    = true
            optionsButton.isEnabled = true
            clearButton.isEnabled = false
            
            //Map
            mapView.showsUserLocation = true
            mapView.userTrackingMode = self.options.userTrackingMode
            mapView.showsTraffic = self.options.showTraffic
            mapView.delegate = self

            //Location Manager
            locationManager.desiredAccuracy = self.options.gpsPrecision
            locationManager.distanceFilter  = self.options.distanceBetweenMeasurements
            locationManager.allowsBackgroundLocationUpdates = self.options.backgroundUpdates
            locationManager.startUpdatingLocation()
            if self.options.headingAvailable {
                locationManager.startUpdatingHeading()
            }
        }
    }

    // MARK: - BCOptionsSheetDelegate
    func dismissWithUpdatedOptions(_ updatedOptions : BCOptions?) {
        self.dismiss(animated: true) {
            if let op = updatedOptions {
                self.options = op
                DispatchQueue.main.async {
                    self.updateOutputWithState()
                }
            }
        }
    }
    
}

