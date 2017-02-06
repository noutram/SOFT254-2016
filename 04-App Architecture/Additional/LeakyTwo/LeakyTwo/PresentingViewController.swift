//
//  PresentingViewController.swift
//  LeakyTwo
//
//  Created by Nicholas Outram on 08/07/2016.
//  Copyright © 2016 Nicholas Outram. All rights reserved.
//

import UIKit

class PresentingViewController: UIViewController, PresentedViewControllerProtocol {
    @IBOutlet weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismiss(_ withResult : String?) -> Void {
        self.dismiss(animated: true) {
            if let resStr = withResult {
                self.resultLabel.text = resStr
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let dvc = segue.destination as? PresentedViewController else { return }
        
        if segue.identifier != "NUMBER" {
            return
        }
        dvc.delegate = self
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
