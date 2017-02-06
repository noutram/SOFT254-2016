//
//  ViewController.swift
//  UIStuff
//
//  Created by Nicholas Outram on 21/11/2016.
//  Copyright © 2016 Nicholas Outram. All rights reserved.
//

import UIKit

public class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {

   //Strong outlets
   var responseLabel: UILabel!
   var segment: UISegmentedControl!
   var button: UIButton!
   
   public var storeNewValue : ((Int) -> Void)?
   public var finished : ((Void) -> Void)?
   
   //Private model data - used for displaying in a pop over
   var data = [String]()
   
   override public func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
   }

   override public func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }


   @IBAction func doSelectionChanged(_ sender: Any) {
      let sel : Int = 1 + self.segment.selectedSegmentIndex
      let strResult : String
      
      switch(sel) {
      case 1:
         strResult = "Disagree"
      case 2:
         strResult = "Slightly Disagree"
      case 3:
         strResult = "Slightly Agree"
      case 4:
         strResult = "Agree"
      default:
         strResult = "Error"
      }
      
      //Update model
      data.append(strResult)
      
      //Update UI
      self.responseLabel.text = strResult
      
      //Send back to playground
      storeNewValue?(sel)
   }
   
   @IBAction func doFinished(_ sender: Any) {
      self.responseLabel.text = "?"
      let tvc = TableViewController()
      tvc.modalPresentationStyle = .popover
      tvc.data = data
      
      //Get hold of and configure the popOverPresentationController
      let pop = tvc.popoverPresentationController
      pop?.sourceView = self.button
      pop?.sourceRect = self.button.bounds
      pop?.delegate = self
      
      //Present popover controller
      self.present(tvc, animated: true, completion: { [unowned self] in
         self.finished?() //Message playground
         self.data.removeAll() //Flush cache
      })
   }
   
   //Prevent adaptivity (otherwise the popover fills the screen)
   public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      return UIModalPresentationStyle.none
   }
   
   public override func loadView() {
      let hostView = UIView(frame: CGRect(x: 0, y: 0, width: 480, height: 320))
      
      hostView.layer.borderWidth = 1
      hostView.layer.borderColor = UIColor.gray.cgColor
      hostView.backgroundColor = .white
      
      segment = UISegmentedControl(items: ["Disagree", "Slightly Disagree", "Slightly Agree", "Agree"])
      segment.translatesAutoresizingMaskIntoConstraints = false
      segment.isMomentary = true
      segment.apportionsSegmentWidthsByContent = true
      
      let title = UILabel(frame: .zero)
      title.text = "Swift is the perfect beginners language"
      title.translatesAutoresizingMaskIntoConstraints = false
      
      responseLabel = UILabel(frame: .zero)
      responseLabel.text = "?"
      responseLabel.translatesAutoresizingMaskIntoConstraints = false
      
      button = UIButton(type: .system)
      button.setTitle("Done", for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      
      hostView.addSubview(segment)
      hostView.addSubview(title)
      hostView.addSubview(responseLabel)
      hostView.addSubview(button)
      
      //Get the margins of the top level UIViewObject
      let margins = hostView.layoutMarginsGuide
      
      //Center the segment
      segment.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
      segment.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
      
      //Place question above
      title.bottomAnchor.constraint(equalTo: segment.topAnchor, constant: -40).isActive = true
      title.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
      
      //Place the response below
      responseLabel.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 40).isActive = true
      responseLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
      
      //Place the button below the response
      button.topAnchor.constraint(equalTo: responseLabel.bottomAnchor, constant: 40).isActive = true
      button.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true

      
      //Hook up actions
      segment.addTarget(self, action: #selector(doSelectionChanged), for: .valueChanged)
      button.addTarget(self, action: #selector(doFinished), for: .touchDown)
      
      self.view = hostView

   }
   
   public func refresh() {
      let _ = self.view?.subviews.map { $0.setNeedsDisplay() }
   }
   
}

