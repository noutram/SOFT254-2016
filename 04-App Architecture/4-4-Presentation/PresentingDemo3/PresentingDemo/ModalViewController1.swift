//
//  ModalViewController1.swift
//  PresentingDemo
//
//  Created by Nicholas Outram on 14/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import UIKit

protocol ModalViewController1Protocol : class {
    func dismissWithStringData(_ str : String)
}

class ModalViewController1: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    var titleText : String = "Default Title"
    
    weak var delegate : ModalViewController1Protocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = titleText
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

    @IBAction func doDismiss(_ sender: AnyObject) {
        delegate?.dismissWithStringData("Message from DEMO 1")
    }

}
