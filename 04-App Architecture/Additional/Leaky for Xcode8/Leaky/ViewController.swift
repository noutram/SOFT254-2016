//
//  ViewController.swift
//  Leaky
//
//  Created by Nicholas Outram on 06/07/2016.
//  Copyright © 2016 Nicholas Outram. All rights reserved.
//

import UIKit

class ParentObject {
    
    var child : ChildObject?
    
    init() {
        child = ChildObject(withParent: self)
        print("Created a child object")
    }
    
    deinit {
        print("Parent deallocating")
    }
    
}

class ChildObject {

    var parent : ParentObject?  //Reverse reference - THIS IS STRONG HENCE THE LEAK
    
    init(withParent : ParentObject) {
        parent = withParent
        print("Child allocated")
    }
    
    deinit {
        print("Child Deallocating")
    }
}


class ViewController: UIViewController {

    fileprivate var model : ParentObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doAlloc(_ sender: AnyObject) {
        model = ParentObject()
    }

    @IBAction func doNil(_ sender: AnyObject) {
        model = nil
    }
}

