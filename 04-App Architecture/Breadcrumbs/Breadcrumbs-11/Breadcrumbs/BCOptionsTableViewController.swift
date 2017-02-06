//
//  BCOptionsTableViewController.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 22/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import UIKit

protocol BCOptionsSheetDelegate : class {
    func dismissWithUpdatedOptions(_ updatedOptions : BCOptions?)
}

class BCOptionsTableViewController: UITableViewController {
    
    // MARK: - Outlets
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
    
    //Local copy of the Options
    var options : BCOptions = BCOptions()
        
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //Initialise the UI
        updateUIWithState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUIWithState() {
        self.backgroundUpdateSwitch.isOn = self.options.backgroundUpdates
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
    
    func updatedateStateFromUI() {
        self.options.backgroundUpdates = self.backgroundUpdateSwitch.isOn
        self.options.headingUP = self.headingUPSwitch.isOn
        self.options.showTraffic = self.showTrafficSwitch.isOn
        self.options.distanceBetweenMeasurements = Double(self.distanceSlider.value)
        self.options.gpsPrecision = Double(self.gpsPrecisionSlider.value)
    }

    // MARK: - Table view data source


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    
    @IBAction func doBackgroundUpdateSwitch(_ sender: AnyObject) {
        print("\(#function)")
        updatedateStateFromUI()
    }
    
    @IBAction func doHeadingUpSwitch(_ sender: AnyObject) {
        updatedateStateFromUI()
        print("\(#function)")
    }
    
    @IBAction func doShowTrafficSwitch(_ sender: AnyObject) {
        updatedateStateFromUI()
        print("\(#function)")
    }
    
    @IBAction func doDistanceSliderChanged(_ sender: AnyObject) {
        self.distanceLabel.text = String(format: "%d", Int(self.distanceSlider.value))
        updatedateStateFromUI()
        print("\(#function)")
    }
    
    @IBAction func doGPSPrecisionSliderChanged(_ sender: AnyObject) {
        self.gpsPrecisionLabel.text = String(format: "%d", Int(self.gpsPrecisionSlider.value))
        updatedateStateFromUI()
        print("\(#function)")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 4 {
            if indexPath.row == 0 {
                self.delegate?.dismissWithUpdatedOptions(self.options)
            } else {
                self.delegate?.dismissWithUpdatedOptions(nil)
            }
        }
    }
    
}
