//
//  ViewController.swift
//  BMI
//
//  Created by Nicholas Outram on 30/12/2014.
//  Copyright (c) 2014 Plymouth University. All rights reserved.
//
// 04-11-2015  Updated for Swift 2

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
   var weight : Double?
   var height : Double?
   var bmi : Double? {
      get {
         if (weight != nil) && (height != nil) {
            return weight! / (height! * height!)
         } else {
            return nil
         }
      }
   }
   
   @IBOutlet weak var bmiLabel: UILabel!
   @IBOutlet weak var heightTextField: UITextField!
   @IBOutlet weak var weightTextField: UITextField!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   //This function dismissed the keyboard
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
   }
   
   func updateUI() {
      if let b = self.bmi {
         self.bmiLabel.text = String(format: "%4.1f", b)
      }
   }
   
//   //Called when ever the textField looses focus
//   func textFieldDidEndEditing(textField: UITextField) {
//      
//      //First we check if textField.text actually contains a (wrapped) String
//      guard let txt : String = textField.text else {
//         //Simply return if not
//         return
//      }
//      
//      //At this point, txt is of type String. Here is a nested function that will be used
//      //to parse this string, and convert it to a wrapped Double if possible.
//      func conv(numString : String) -> Double? {
//         let result : Double? = NSNumberFormatter().numberFromString(numString)?.doubleValue
//         return result
//      }
//      
//      //Which textField is being edit?
//      switch (textField) {
//         
//      case heightTextField:
//         self.height = conv(txt)
//         
//      case weightTextField:
//         self.weight = conv(txt)
//         
//         //default must be here to give complete coverage. A safety precaution.
//      default:
//         print("Something bad happened!")
//         
//      } //end of switch
//      
//      //Last of all, update the user interface.
//      updateUI()
//      
//   }
   
   // SOLUTION TO CHALLENGE
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      guard let txt = textField.text else {
         return false
      }
      
      let conv = { NumberFormatter().number(from: $0)?.doubleValue }
      
      let newString = NSMutableString(string: txt)
      newString.replaceCharacters(in: range, with: string)
      
      switch (textField) {
         
      case self.weightTextField:
         self.weight = conv(newString as String)
         
      case self.heightTextField:
         self.height = conv(newString as String)
         
      default:
         break
         
      } //end switch
      
      updateUI()
      
      
      
      return true
   }
   
}




