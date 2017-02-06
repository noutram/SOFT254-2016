//
//  PresentedViewController.swift
//  LeakyTwo
//
//  Created by Nicholas Outram on 08/07/2016.
//  Copyright © 2016 Nicholas Outram. All rights reserved.
//

import UIKit

protocol PresentedViewControllerProtocol : class {
    func dismiss(_ withResult : String?) -> Void
}
class PresentedViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var stepper: UIStepper!
    
    var val : Float = 50.0 {
        didSet {
            if let update = self.updateUI {
                update(val)
            }
        }
    }
    
    //Closure that updates the UI when the val changes
    var updateUI : ((_ newVal : Float) -> Void)?
    
    //Callback closure
    weak var delegate : PresentedViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doSliderchanged(_ sender: AnyObject) {
        guard let slider = sender as? UISlider else { return }
        
        //self.updateUI = { [unowned self] in   //CORRECT VERSION
        self.updateUI = {                       //LEAKY VERSION
            self.label.text = String(format: "%3.0f", $0)
            self.stepper.value = Double($0)
        }
        
        //Update property
        self.val = slider.value
    
    }

    
    @IBAction func doStepper(_ sender: AnyObject) {
        guard let stepr = sender as? UIStepper else { return }
        
        //self.updateUI = { [unowned self] in   //CORRECT VERSION
        self.updateUI = {                       //LEAKY VERSION
            self.label.text = String(format: "%3.0f", $0)
            self.slider.value = $0
        }
        
        //Update property
        self.val = Float(stepr.value)
    }
    
    @IBAction func doSave(_ sender: AnyObject) {
        //Send result back to presenting view controller
        self.delegate?.dismiss(String(format: "%3.0f", self.val))
    }
    
    
    @IBAction func doCancel(_ sender: AnyObject) {
        //Send nil back to presenting view controller
        self.delegate?.dismiss(nil)
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
