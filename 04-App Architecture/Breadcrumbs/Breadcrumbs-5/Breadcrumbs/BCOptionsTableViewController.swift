//
//  BCOptionsTableViewController.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 22/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import UIKit

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
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    
    @IBAction func doHeadingUpSwitch(_ sender: AnyObject) {
        print("\(#function)")
    }
    
    @IBAction func doShowTrafficSwitch(_ sender: AnyObject) {
        print("\(#function)")
    }
    
    @IBAction func doDistanceSliderChanged(_ sender: AnyObject) {
        print("\(#function)")
    }
    
    @IBAction func doGPSPrecisionSliderChanged(_ sender: AnyObject) {
        print("\(#function)")
    }

}
