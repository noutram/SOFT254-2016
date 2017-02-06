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
   
   //
   // DATA MODEL
   //
   //Stored properties
   var weight : Double?
   var height : Double?
   
   //Computed properties
   var bmi : Double? {
      get {
         if (weight != nil) && (height != nil) {
            return weight! / (height! * height!)
         } else {
            return nil
         }
      }
   }
   
   //Initialised arrays of values to be displayed in the picker
   let listOfHeightsInM  = Array(140...220).map({Double($0) * 0.01})
   let listOfWeightsInKg = Array(80...240).map({Double($0) * 0.5})
   
   //
   // OUTLETS
   //
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
   
   //This function dismisses the keyboard when return is tapped
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
   }
   
   //Synchronise the user interface when the model is updated
   func updateUI() {
      if let b = self.bmi {
         self.bmiLabel.text = String(format: "%4.1f", b)
      }
   }
   
   //Called when ever the textField looses focus
   func textFieldDidEndEditing(_ textField: UITextField) {
      
      //First we check if textField.text actually contains a (wrapped) String
      guard let txt = textField.text else {
         //Simply return if not
         return
      }
      
      //At this point, txt is of type String. Here is a nested function that will be used
      //to parse this string, and convert it to a wrapped Double if possible.
      let val = NumberFormatter().number(from: txt)?.doubleValue
      
      //Which textField is being edit?
      switch (textField) {
         
      case heightTextField:
         self.height = val
         
      case weightTextField:
         self.weight = val
         
         //default must be here to give complete coverage. A safety precaution.
      default:
         print("Something bad happened!")
         
      } //end of switch
      
      //Last of all, update the user interface.
      updateUI()
      
   }
   
   //Return the numeber of components in the picker (spinning barrels). We only want 1
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
   }
   
   //For a given component, return the number of rows that are displayed / can be selected
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
   
   //For this example, the picker is populated with Strings, derived from arrays.
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
   
   //When a user picks a value, this method is called.
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




