//
//  CustomSideMenuController.swift
//  Example
//
//  Created by Teodor Patras on 16/06/16.
//  Copyright © 2016 teodorpatras. All rights reserved.
//

import Foundation
import SideMenuController

class CustomSideMenuController: SideMenuController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        performSegueWithIdentifier("showCenterController1", sender: nil)
        performSegueWithIdentifier("containSideMenu", sender: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ToggleMenu), name:"ToggleMenu", object: nil)
    }
    func style(){

        
    }
    func ToggleMenu(notification: NSNotification){
        self.toggle()
    }
}