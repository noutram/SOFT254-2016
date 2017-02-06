//
//  ViewController.swift
//  BMI
//
//  Created by Nicholas Outram on 30/12/2014.
//  Copyright (c) 2014 Plymouth University. All rights reserved.
//
// 04-11-2015  Updated for Swift 2

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
   class func doDiv100(_ u : Int) -> Double {
      return Double(u) * 0.01
   }
   
   class func doDiv2(_ u : Int) -> Double {
      return Double(u) * 0.5
   }
   
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
   let listOfHeightsInM  = Array(140...220).map(ViewController.doDiv100)
   let listOfWeightsInKg = Array(80...240).map(ViewController.doDiv2)
   
   @IBOutlet weak var bmiLabel: UILabel!
   @IBOutlet weak var heightTextField: UITextField!
   @IBOutlet weak var weightTextField: UITextField!
   @IBOutlet weak var heightPickerView: UIPickerView!
   @IBOutlet weak var weightPickerView: UIPickerView!
   
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
   
   //Called when ever the textField looses focus
   func textFieldDidEndEditing(_ textField: UITextField) {
      
      //First we check if textField.text actually contains a (wrapped) String
      guard let txt : String = textField.text else {
         //Simply return if not
         return
      }
      
      //At this point, txt is of type String. Here is a nested function that will be used
      //to parse this string, and convert it to a wrapped Double if possible.
      func conv(_ numString : String) -> Double? {
         let result : Double? = NumberFormatter().number(from: numString)?.doubleValue
         return result
      }
      
      //Which textField is being edit?
      switch (textField) {
         
      case heightTextField:
         self.height = conv(txt)
         
      case weightTextField:
         self.weight = conv(txt)
         
         //default must be here to give complete coverage. A safety precaution.
      default:
         print("Something bad happened!")
         
      } //end of switch
      
      //Last of all, update the user interface.
      updateUI()
      
   }
   
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

      switch (pickerView) {
      case heightPickerView:
         return self.listOfHeightsInM.count
         
      case weightPickerView:
         return self.listOfWeightsInKg.count
         
      default:
         return 1
         
      }
   }
   
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      
      switch (pickerView) {
      case heightPickerView:
         return String(format: "%4.2f", self.listOfHeightsInM[row])
         
      case weightPickerView:
         return String(format: "%4.1f", self.listOfWeightsInKg[row])
         
      default:
         return ""
      }
      
   }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      switch (pickerView) {
      case heightPickerView:
         self.height = self.listOfHeightsInM[row]
         
      case weightPickerView:
         self.weight = self.listOfWeightsInKg[row]
         
      default:
         break
      }
      
      updateUI()
   }
   
}




