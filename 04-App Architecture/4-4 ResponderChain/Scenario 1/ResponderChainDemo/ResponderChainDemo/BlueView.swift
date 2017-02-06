//
//  BlueView.swift
//  ResponderChainDemo
//
//  Created by Nicholas Outram on 15/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import UIKit

class BlueView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        printNextRepsonderAsString()
        if let swState = switchState(0), swState == true {
            //Pass up the responder chain
            super.touchesBegan(touches, with: event)
        }

    }

    
}

