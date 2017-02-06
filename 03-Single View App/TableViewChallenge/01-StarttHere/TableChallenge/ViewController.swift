//
//  ViewController.swift
//  TableChallenge
//
//  Created by Nicholas Outram on 10/02/2015.
//  Copyright (c) 2015 Plymouth University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //
    //MARK: properties
    //
    
    //******************************************************************************************
    // MODEL DATA
    //
    //Because the table is not editable, I've made the following immutable
    //
    let arrayOfThings = ["1. Hook up datasource", "2. Hook up delegate", "3. Conform to protocols",
        "4. Implement required methods", "   4.1 numberOfSectionsInTableView", "   4.2 numberOfRowsInSection",
        "   4.3 cellForRowAtIndexPath", "5. Implement Additional Methods", "   5.1 didSelectRowAtIndexPath"]
    //
    // I've used spaces in the strings to give the impression of indentation
    //
    //******************************************************************************************
    
    
    //
    //MARK: inherited / overridden methods
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

    //******************************************************************************************
    //
    // I HAVE PROVIDED THE CODE BELOW TO RETURN A stock UITableViewCell populated with a string.
    //
    // When we cover tables formally, you will learn more elegant ways to achieve this.
    //******************************************************************************************
    
    
    //Return a UITableViewCell (table row) - I will use a stock item, but typically you would make your own
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        //Construct a cell (not the most efficient method)
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        
        //See here how Optional Chaining is used to conditionally set a property if it is not nil
        cell.textLabel?.text = self.arrayOfThings[indexPath.row]
        return cell
    }
    
    //Call back when a user taps on a row in a given section.
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {

        //We only have one section, so use indexPath.row to dereference the array
        let selectedString = self.arrayOfThings[indexPath.row]
        print("You picked \(selectedString)")
        
        //Animate the deselection
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

