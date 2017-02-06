//
//  ViewController.swift
//  Rotate1
//
//  Created by Nicholas Outram on 25/07/2016.
//  Copyright © 2016 Nicholas Outram. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {

   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.navigationController?.delegate = self
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   //
   // To quote the docs:
   // 
   //   "A navigation controller object does not consult the view controllers on its navigation stack when determining the supported interface orientations."
   //
   
   // ***************************************************************************************
   // * The following are only called when used as a root view controller or when presented *
   // ***************************************************************************************
   
   override var shouldAutorotate : Bool {
      //This controller can rotate
      return true
   }
   
   //For when this is a root view controller or presented
   override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
      return .allButUpsideDown
   }
   
   
   // ***************************************************************************************
   // *      The following are only called when contained in a navigation controller        *
   // ***************************************************************************************
   
 
   func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
      //When embedded in a navigation controller, only portrait is supported
      return .portrait
   }
   
   func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
      //Use portrait with the nav controller
      return .portrait
   }
   
 
   
}

