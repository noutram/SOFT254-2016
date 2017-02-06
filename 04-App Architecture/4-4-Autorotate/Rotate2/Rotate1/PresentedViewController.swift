//
//  PresentedViewController.swift
//  Rotate1
//
//  Created by Nicholas Outram on 25/07/2016.
//  Copyright © 2016 Nicholas Outram. All rights reserved.
//

import UIKit

class PresentedViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      if let _ = self.navigationController {
         self.titleLabel.text = "Pushed"
         self.dismissButton.isHidden = true
         
      } else {
         self.titleLabel.text = "Presented"
      }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   @IBAction func doDismiss(_ sender: AnyObject) {
      self.dismiss(animated: true, completion: { })
   }
      
   
   // ***************************************************************************************
   // * The following are only called when used as a root view controller or when presented *
   // ***************************************************************************************
   override var shouldAutorotate : Bool {
      return false
   }
   
   override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
      return .allButUpsideDown
   }
   
   //When a root view controller or when presented
   override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
      //For presentation, only use landscapeRight
      return .landscapeRight
   }
   

}
