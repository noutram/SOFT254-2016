//
//  ViewController.swift
//  TableChallenge
//
//  Created by Nicholas Outram on 10/02/2015.
//  Copyright (c) 2015 Plymouth University. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //
    //MARK: properties
    //
    
    //Because the table is not editable, I've made the following immutable
    let arrayOfThings = ["1. Hook up datasource", "2. Hook up delegate", "3. Conform to protocols", "4. Implement required methods", "   4.1 numberOfSectionsInTableView", "   4.2 numberOfRowsInSection", "   4.3 cellForRowAtIndexPath", "5. Implement Additional Methods", "   5.1 didSelectRowAtIndexPath"]
    
    
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

    
    //
    //MARK: UITableViewDataSource conformance
    //
    
    //Return the number of sections - for this plain table, it's just 1
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Return the numner of rows in a given section. Look this up from the data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfThings.count
    }
    
    //Return a UITableViewCell (table row) - I will use a stock item, but typically you would make your own
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        //See here how Optional Chaining is used to conditionally set a property if it is not nil
        cell.textLabel?.text = self.arrayOfThings[indexPath.row]
        return cell
    }
    
    //
    //MARK: UITableViewDelegate conformance
    //
    
    //Call back when a user taps on a row in a given section.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //We only have one section, so use indexPath.row to dereference the array
        let selectedString = self.arrayOfThings[indexPath.row]
        print("You picked \(selectedString)")
        
        //Animate the deselection
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

