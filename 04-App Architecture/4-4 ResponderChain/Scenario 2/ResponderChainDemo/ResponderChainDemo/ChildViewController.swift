//
//  ChildViewController.swift
//  ResponderChainDemo
//
//  Created by Nicholas Outram on 17/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import UIKit

class ChildViewController: UIViewController {

    @IBOutlet weak var passUpSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.printNextRepsonderAsString()
        
        if passUpSwitch.isOn {
            //Pass up the responder chain
            super.touchesBegan(touches, with: event)
        }
    }

}
