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
        performSegue(withIdentifier: "showCenterController1", sender: nil)
        performSegue(withIdentifier: "containSideMenu", sender: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(ToggleMenu), name:NSNotification.Name(rawValue: "ToggleMenu"), object: nil)
    }
    func style(){

        
    }
    func ToggleMenu(_ notification: Notification){
        self.toggle()
    }
}
