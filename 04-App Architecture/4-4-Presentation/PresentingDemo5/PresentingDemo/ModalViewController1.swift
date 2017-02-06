//
//  ModalViewController1.swift
//  PresentingDemo
//
//  Created by Nicholas Outram on 14/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import UIKit

protocol ModalViewController1Protocol : class {
    func dismissWithStringData(_ str : String)
}

class ModalViewController1: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    var titleText : String = "Default Title"
    
    weak var delegate : ModalViewController1Protocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = titleText
    }

    //*****************************
    //Create a view programatically
    //*****************************
    override func loadView() {
        // super.loadView() would load from a Nib
        // As we have overridden this, then the nib loading mechanism is disabled.
        
        //Has a nib been provided?
        if let _ = self.nibName {
            super.loadView()
            return
        }
        
        //Instantiate a view
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.lightGray
        
        //Instantiate the label (no position specified)
        let label = UILabel()
    
        //Instantiate the button
        let button = UIButton(type: UIButtonType.roundedRect)
        
        //Set the properties of the label
        label.text = "Demo 5"       //Set property
        label.textAlignment = NSTextAlignment.center
        self.titleLabel = label     //Setup outlet
        
        //Set the properties of the button
        button.setTitle("Dismiss", for: UIControlState())
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(ModalViewController1.doDismiss(_:)), for: UIControlEvents.touchUpInside)
        button.showsTouchWhenHighlighted = true
        
        //Add label to the view heirarchy
        self.view.addSubview(label)
        self.view.addSubview(button)
        
        //Add constraints (center of the view)
        let c1 = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)
        let c2 = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0)
        let c3 = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: label, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 60.0)
        let c4 = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: label, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)

        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(c1)
        self.view.addConstraint(c2)
        self.view.addConstraint(c3)
        self.view.addConstraint(c4)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doDismiss(_ sender: AnyObject) {
        delegate?.dismissWithStringData("Message from DEMO 1")
    }
      
   


}
