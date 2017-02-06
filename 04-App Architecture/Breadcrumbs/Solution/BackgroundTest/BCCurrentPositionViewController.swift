//
//  ViewController.swift
//  BackgroundTest
//
//  Created by Nicholas Outram on 30/11/2015.
//  Copyright © 2015 Plymouth University. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class BCCurrentPositionViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, BCOptionsSheetDelegate {

    // **********************
    // MARK: Enumerated types
    // **********************

    /// The application state - "where we are in a known sequence"
    enum AppState {
      case waitingForViewDidLoad
      case requestingAuth
      case liveMapNoLogging
      case liveMapLogging
      
      init() {
         self = .waitingForViewDidLoad
      }
      
      /// Returns a string description of a state using a computed property. Used by the print function when logging.
      var description : String {
         get {
            switch (self) {
            case .waitingForViewDidLoad:
               return "Wating for ViewDidLoad"
            case .requestingAuth:
               return "Requesting Authorisation"
            case .liveMapNoLogging:
               return "Live Map with no location logging"
            case .liveMapLogging:
               return "Live Map with location Logging"
            }
         }
      }
    }

    /// The type of input (and its value) applied to the state machine
    enum AppStateInputSource {
      case none
      case start
      case authorisationStatus(Bool)
      case userWantsToStart(Bool)
    }

    // *************
    // MARK: Outlets
    // *************
   
    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var optionsButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!

    // ****************
    // MARK: Properties
    // ****************

    /// Appliction state. Important to manage the possible sequence of events that can occur in an app life cycle
    /// - warning: Should only be set via the `updateStateWithInput()` method
    fileprivate var state : AppState     = AppState() {
      willSet {
         //Useful logging info
         print("Changing from state \(state) to state \"\(newValue)\"")
      }
      didSet {
         //If the state changes, so the output changes immediately
         self.updateOutputWithState()
      }
    }

    ///Default set of options (backed by user defaults)
    fileprivate var options : BCOptions = BCOptions() {
      didSet {
         //Persist the options to user defaults
         options.updateDefaults()
      }
    }

    ///This property is "lazy". Only runs once, when the property is first referenced
    fileprivate lazy var locationManager : CLLocationManager = {
      [unowned self] in
      print("Instantiating and initialising the location manager \"lazily\"")
      print("This will only run once")
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
    }()               //Note the parenthesis

    //Internal flag for deferred updates
    var deferringUpdates : Bool = false
   
    // ************************
    // MARK: Class Initialisers
    // ************************
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      print("\(#file), \(#function)")
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
      print("\(#file), \(#function)")
      super.init(coder: aDecoder)
    }
    
    // MARK: -
    // *******************************************
    // MARK: UIViewController specific lifecycle
    // *******************************************
    // MARK: -
    // MARK: Bringing the controller up
    override func loadView() {
        //This is the function that loads view objects from nib files
        super.loadView()
        print("\(#file), \(#function)")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        print("\(#file), \(#function)")
    }

    override func viewDidLoad() {
    //Called once the view is loaded in memory (and everything is hoooked up)
      super.viewDidLoad()
      print("\(#file), \(#function)")
      // Do any additional setup after loading the view, typically from a nib.
      
      //Set initial app state - this kicks off everything else
      self.updateStateWithInput(.start)
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      print("\(#file), \(#function)")
    }
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      print("\(#file), \(#function)")
    }
    
    // MARK: Updates to layout
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        //Forward the message to presented / child view controllers
        super.willTransition(to: newCollection, with: coordinator)
        print("\(#file), \(#function) : new traits \(newCollection)")
    }
    override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      print("\(#file), \(#function)")
    }
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      print("\(#file), \(#function)")
    }
    // MARK: Tearing the controller down
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      print("\(#file), \(#function)")
    }
    override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      print("\(#file), \(#function)")
    }
    deinit {
      print("\(#file), \(#function)")
    }
    
   // MARK: -
   // ************************
   // MARK: Events and Actions
   // ************************
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
      print("\(#file), \(#function)")
   }
    
   func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      print("Authorisation changed to \(status.rawValue)")
      if status == CLAuthorizationStatus.authorizedAlways {
         print("Authorisation granted")
         self.updateStateWithInput(.authorisationStatus(true))
      } else {
         self.updateStateWithInput(.authorisationStatus(false))
      }
   }
   
   @IBAction func doStart(_ sender: AnyObject) {
      self.updateStateWithInput(.userWantsToStart(true))
   }

   @IBAction func doStop(_ sender: AnyObject) {
      //Save model when ever we enter this state
      globalModel.save() {
         //Upload to CloudKit
         globalModel.uploadToCloudKit() { (didSucceed : Bool) in
            // TBD: This really needs a better state model
            print("Successful upload: \(didSucceed)")
         }
      }
      //Update UI
      self.updateStateWithInput(.userWantsToStart(false))
   }
   
   @IBAction func doClear(_ sender: AnyObject) {
      globalModel.erase() {
        globalModel.save() {
            self.updateStateWithInput(.none)
            globalModel.deleteDataFromCloudKit() { (didSucceed : Bool) in
                print("Data delete \(didSucceed)")
            }
        }
      }
   }
   
   //Called before a segue performs navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      print("\(#file), \(#function)")
      
      //Pass data forwards to the *presented* view controller
      if segue.identifier == "ModalOptions" {
         if let dstVC = segue.destination as? BCOptionsTableViewController {
            dstVC.delegate = self
            dstVC.options = self.options  //Pass a COPY
         }
      }
   }
   
   // ****************************
   // MARK: BCOptionsSheetDelegate
   // ****************************
   
   func dismissWithUpdatedOptions(_ updatedOptions: BCOptions?) {
      print("\(#file), \(#function)")
    
      //Using a trailing closure syntax, dismiss the presented and run completion handler
      self.dismiss(animated: true) {
         print("Presented animation has now completed")
        
        //If saved, updatedOptions will have a wrapped copy
        if let op = updatedOptions {
            self.options = op             //Make copy
            
            //Update the application UI and Location manager
            DispatchQueue.main.async {
                self.updateOutputWithState()
            }
        }
        
      }
   }
   

   
   
   // *******************************
   // MARK: CLLocationManagerDelegate
   // *******************************

   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("Location manager failed \(error)")
   }
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let _ = locations.last else { return }
      
      print("\(locations.count) Location(s) Updated.")

      //Store in array
      globalModel.addRecords(locations) {
         //Update overlay of the journey
         self.updateMapOverlay()
      }
      
      /// Power saving option
      if (!self.deferringUpdates) {
         manager.allowDeferredLocationUpdates(untilTraveled: self.options.distanceBetweenMeasurements*100.0, timeout: CLTimeIntervalMax)
         self.deferringUpdates = true
      }
      
   }
   
   func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
      print("Finished deferring updates")
      self.deferringUpdates = false
   }
  
    // ************************
    // MARK: Update Map Overlay
    // ************************
    func updateMapOverlay() {
        globalModel.getArray() { (array : [CLLocation]) in
            
            //Update overlay of the journey
            var arrayOfCoords : [CLLocationCoordinate2D] = array.map{$0.coordinate}  //Array of coordinates
            let line = MKPolyline(coordinates: &arrayOfCoords, count: arrayOfCoords.count)
            self.mapView.removeOverlays(self.mapView.overlays) //Remove previous line
            self.mapView.add(line)                      //Add updated
        }
    }
    
   // ***********************
   // MARK: MKMapViewDelegate
   // ***********************
   
   // Moving the map will reset the user tracking mode. I reset it back
   func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
      mapView.userTrackingMode = self.options.userTrackingMode
   }
   
   // For drawing the bread-crumbs
   func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let path = MKPolylineRenderer(overlay: overlay)
      path.strokeColor = UIColor.purple
      path.lineWidth = 2.0
      path.lineDashPattern = [10, 4]
      return path
   }
   
   // **************************
   // MARK: Finite State Machine
   // **************************
   
   //UPDATE STATE
   func updateStateWithInput(_ ip : AppStateInputSource)
   {
      var nextState = self.state
      
      switch (self.state) {
      case .waitingForViewDidLoad:
         
         //Check inputs type
         if case .start = ip  {
            nextState = .requestingAuth
         }
         
      case .requestingAuth:
         //Ensure user has given permission  to access location

         //Check inputs type and associated value
         if case .authorisationStatus(let val) = ip, val == true {
            nextState = .liveMapNoLogging
         }
         
      case .liveMapNoLogging:
         // Authorisation is given
         
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
         
      } //end switch
      
      //State Transition (will trigger updates in the output)
      self.state = nextState
   }
   
   //UPDATE (MOORE) OUTPUTS
   func updateOutputWithState() {
      switch (self.state) {
      case .waitingForViewDidLoad:
         break
         
      case .requestingAuth:
         
         //Request authorisation from the user to log location in the background
         self.locationManager.requestAlwaysAuthorization()
         
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
         // We now have permission to use location
         
         //Buttons for logging
         startButton.isEnabled = true
         stopButton.isEnabled = false
         optionsButton.isEnabled = true
         globalModel.isEmpty() {
            self.clearButton.isEnabled = !$0
         }
         
         //Live Map
         mapView.showsUserLocation = true
         mapView.userTrackingMode = self.options.userTrackingMode
         mapView.showsTraffic = self.options.showTraffic
         mapView.delegate = self
         updateMapOverlay()
         
         //Set Location manger state
         locationManager.desiredAccuracy = self.options.gpsPrecision
         locationManager.distanceFilter = self.options.distanceBetweenMeasurements
         locationManager.allowsBackgroundLocationUpdates = false
         locationManager.stopUpdatingLocation()
         locationManager.stopUpdatingHeading()
         
      case .liveMapLogging:
         //Buttons
         startButton.isEnabled   = false
         stopButton.isEnabled    = true
         clearButton.isEnabled   = false
         optionsButton.isEnabled = true
         
         //Map
         mapView.showsUserLocation = true
         mapView.userTrackingMode = self.options.userTrackingMode
         mapView.showsTraffic = self.options.showTraffic
         mapView.delegate = self
         
         //Location manger
         locationManager.desiredAccuracy = self.options.gpsPrecision
         locationManager.distanceFilter = self.options.distanceBetweenMeasurements
         locationManager.allowsBackgroundLocationUpdates = self.options.backgroundUpdates
         locationManager.startUpdatingLocation()
         
         if CLLocationManager.headingAvailable() {
            print("Update heading",separator: "********")
            locationManager.startUpdatingHeading()
         } else {
            print("HEADING NOT AVAILABLE",separator: "********")
         }
         

      } //end switch
   }
    
}

