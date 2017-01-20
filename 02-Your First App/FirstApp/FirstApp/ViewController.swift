//
//  ViewController.swift
//  FirstApp
//
//  Created by Nicholas Outram on 20/01/2017.
//  Copyright © 2017 University of Plymouth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   @IBOutlet weak var messageLabel: UILabel!
   
   let messageArray : [String] = [
      "May the force be with you",
      "Live long and prosper",
      "To infinity and beyond",
      "Space is big. You just won't believe how vastly, hugely, mind- bogglingly big it is"]
   
   var index : Int = 0
   
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
      
      let nextString = messageArray[index]
      self.messageLabel.text = nextString
      index += 1
      index %= messageArray.count
   }
}

