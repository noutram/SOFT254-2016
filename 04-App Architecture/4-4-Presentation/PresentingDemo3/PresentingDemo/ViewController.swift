//
//  ViewController.swift
//  PresentingDemo
//
//  Created by Nicholas Outram on 14/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import UIKit



class ViewController: UIViewController, ModalViewController1Protocol {
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? ModalViewController1 {
            vc.delegate = self
            
            switch (segue.identifier) {
                
            case "DEMO1"?:
                vc.titleText = "DEMO 1"
                
            case "DEMO2"?:
                vc.titleText = "DEMO 2"
                
            default:
                break
                
            } //end switch
        } //end if
        

            
        
    }
    @IBAction func doDemo2(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "DEMO2", sender: self)
    }
    
   @IBAction func doDemo3(_ sender: AnyObject) {
     let sb = UIStoryboard(name: "ModalStoryboard", bundle: nil)
      
     if let vc = sb.instantiateViewController(withIdentifier: "DEMO3") as? ModalViewController1 {
         vc.delegate = self
         vc.titleText = "DEMO 3"
         self.present(vc, animated: true, completion: { })
     }
   }
    //Call back
    func dismissWithStringData(_ str: String) {
      self.dismiss(animated: true) {
         self.resultLabel.text = str
      }
    }
}

