//
//  ViewController.swift
//  FirstApp
//
//  Created by Nicholas Outram on 20/01/2017.
//  Copyright © 2017 University of Plymouth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }


   @IBAction func doButtonTap(_ sender: Any) {
      print("You tapped the button")
   }
}

