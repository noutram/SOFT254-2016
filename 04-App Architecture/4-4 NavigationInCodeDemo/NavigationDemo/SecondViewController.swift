//
//  SecondViewController.swift
//  NavigationDemo
//
//  Created by Nicholas Outram on 27/02/2015.
//  Copyright (c) 2015 Plymouth University. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

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

    @IBAction func doTapThis(_ sender: AnyObject) {
        let sb = UIStoryboard(name: "DetailViewController", bundle: nil)
        if let vc = sb.instantiateInitialViewController() as? DetailViewController {
            
            //The following would assume the context to be a navigationController
//            self.navigationController?.pushViewController(vc, animated: true)
            
            //The "adaptive" showViewController - we don't assume the context (how clever!)
            self.show(vc, sender: self)
        }
    }
}
