//
//  BCOptionsTableViewController.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 02/12/2015.
//  Copyright © 2015 Plymouth University. All rights reserved.
//

import UIKit

protocol BCOptionsSheetDelegate : class {
    //Required methods
    func dismissWithUpdatedOptions(_ updatedOptions : BCOptions?)
}

class BCOptionsTableViewController: UITableViewController {
    @IBOutlet weak var backgroundUpdateSwitch: UISwitch!
    @IBOutlet weak var headingUPSwitch: UISwitch!
    @IBOutlet weak var headingUPLabel: UILabel!
    @IBOutlet weak var showTrafficSwitch: UISwitch!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var gpsPrecisionLabel: UILabel!
    @IBOutlet weak var gpsPrecisionSlider: UISlider!

    //Delegate property
    weak var delegate : BCOptionsSheetDelegate?

    //Local copy of all options with defaults
    var options : BCOptions = BCOptions() {
      didSet {
         print("OPTIONS COPY UPDATED in \(#function)")
         //updateUIWithState() //this would cause a crash when this property is set by the presenting controller
      }
    }

    //Functions to synchronise UI and state
    //Error prone, with no clever binding strategies here - just keeping things simple
    func updateUIWithState() {
      self.backgroundUpdateSwitch.isOn = self.options.backgroundUpdates
      //Only devices with heading support can switch on the heading UP support
      if self.options.headingAvailable {
         self.headingUPSwitch.isOn = self.options.headingUP
         self.headingUPSwitch.isEnabled = true
         self.headingUPLabel.alpha = 1.0
      } else {
         self.headingUPSwitch.isOn = false
         self.headingUPSwitch.isEnabled = false
         self.headingUPLabel.alpha = 0.2
      }
      self.showTrafficSwitch.isOn = self.options.showTraffic
      self.distanceSlider.value = Float(self.options.distanceBetweenMeasurements)
      self.distanceLabel.text = String(format: "%d", Int(self.options.distanceBetweenMeasurements))
      self.gpsPrecisionSlider.value = Float(self.options.gpsPrecision)
      self.gpsPrecisionLabel.text = String(format: "%d", Int(self.options.gpsPrecision))
    }

    func updateStateFromUI() {
      self.options.backgroundUpdates = self.backgroundUpdateSwitch.isOn
      self.options.headingUP = self.headingUPSwitch.isOn
      self.options.showTraffic = self.showTrafficSwitch.isOn
      self.options.distanceBetweenMeasurements = Double(self.distanceSlider.value)
      self.options.gpsPrecision = Double(self.gpsPrecisionSlider.value)
    }

    override func awakeFromNib() {
      print("\(#file), \(#function)")
    }

    override func viewDidLoad() {
      print("\(#file), \(#function)")
      super.viewDidLoad()

      guard let _ = self.delegate else {
         print("WARNING - DELEGATE NOTE SET FOR \(self)")
         return
      }
      
      //Initialise the UI
      updateUIWithState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Triggered by a rotation event
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        //Forward the message
        super.willTransition(to: newCollection, with: coordinator)
        
        print("\(#file), \(#function) : new traits \(newCollection)")
    }

    // MARK: Actions
    @IBAction func doBackgroundUpdateSwitch(_ sender: AnyObject) {
      updateStateFromUI()
    }

    @IBAction func doHeadingUpSwitch(_ sender: AnyObject) {
      updateStateFromUI()
    }

    @IBAction func doShowTrafficSwitch(_ sender: AnyObject) {
      updateStateFromUI()
    }

    @IBAction func doDistanceSliderChanged(_ sender: AnyObject) {
      updateStateFromUI()
      self.distanceLabel.text = String(format: "%d", Int(self.distanceSlider.value))
    }

    @IBAction func doGPSPrecisionSliderChanged(_ sender: AnyObject) {
      updateStateFromUI()
      self.gpsPrecisionLabel.text = String(format: "%d", Int(self.gpsPrecisionSlider.value))
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      tableView.deselectRow(at: indexPath, animated: true)
      
      if indexPath.section == 4 {
         if indexPath.row == 0 {
            print("Save tapped")
            self.delegate?.dismissWithUpdatedOptions(self.options)
         } else {
            print("Cancel tapped")
            self.delegate?.dismissWithUpdatedOptions(nil)
         }
      }
    }
    
    // MARK: Rotation
    // New Autorotation support.
    override var shouldAutorotate : Bool {
        return false
    }
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return .portrait
    }
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [.portrait]
    }

}
