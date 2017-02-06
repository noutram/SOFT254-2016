//
//  ViewController.swift
//  ResponderChainDemo
//
//  Created by Nicholas Outram on 15/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import UIKit

extension UIResponder {
    func switchState(_ t : Int) -> Bool? {
        guard let me = self as? UIView else {
            return nil
        }
        for v in me.subviews {
            if let sw = v as? UISwitch, v.tag == t {
                return sw.isOn
            }
        }
        return false
    }
    
    func printNextRepsonderAsString() {
        var result : String = "\(type(of: self)) got a touch event."
        
        if let nr = self.next {
            result += " The next responder is " + type(of: nr).description()
        } else {
            result += " This class has no next responder"
        }
        
        print(result)
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var passUpSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.printNextRepsonderAsString()
        
        if passUpSwitch.isOn {
            //Pass up the responder chain
            super.touchesBegan(touches, with: event)
        }
    }

}

