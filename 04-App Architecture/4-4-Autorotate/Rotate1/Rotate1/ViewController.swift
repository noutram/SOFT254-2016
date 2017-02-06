//
//  ViewController.swift
//  Rotate1
//
//  Created by Nicholas Outram on 25/07/2016.
//  Copyright © 2016 Nicholas Outram. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   @IBOutlet weak var rotateSwitch: UISwitch!
   @IBOutlet weak var leftSwitch: UISwitch!
   @IBOutlet weak var rightSwitch: UISwitch!

   var doesRotate = true
   var leftAllowed = true
   var rightAllowed = true
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }

   @IBAction func doRotateSwitch(_ sender: AnyObject) {
      doesRotate = rotateSwitch.isOn
      UIViewController.attemptRotationToDeviceOrientation()
   }

   @IBAction func doLeftSwitch(_ sender: AnyObject) {
      leftAllowed = leftSwitch.isOn
      UIViewController.attemptRotationToDeviceOrientation()
   }
   
   @IBAction func doRightSwitch(_ sender: AnyObject) {
      rightAllowed = rightSwitch.isOn
      UIViewController.attemptRotationToDeviceOrientation()
   }
   
   override var shouldAutorotate : Bool {
      return doesRotate
   }
   
   override var supportedInterfaceOrientations : UIInterfaceOrientationMask {

      var maskSet : UIInterfaceOrientationMask = .portrait
      
      if leftAllowed {
         maskSet = [maskSet, .landscapeLeft]
      }
      if rightAllowed {
         maskSet = [maskSet, .landscapeRight]
      }
      return maskSet
   }
   
   
}

