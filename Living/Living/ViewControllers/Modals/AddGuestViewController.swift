//
//  AddGuestViewController.swift
//  Living
//
//  Created by Nelson FB on 18/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import Foundation
import Presentr


class AddGuestViewController: UIViewController {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var btn_add: UIButton!
    
    
    
    @IBAction func AddGuest(sender: AnyObject) {
        
        dismissViewControllerAnimated(true) {
            let email = self.txt_email.text
            
            if(ArSmartUtils.isValidEmail(email!)){
                
                let guest = Guest(email: email!)
                guest.save(ArSmartApi.sharedApi.getToken(),hub: ArSmartApi.sharedApi.hub!.hid, completion: { (IsError, result) in
                    if(IsError){
                        NSNotificationCenter.defaultCenter().postNotificationName("AddGuestError", object: nil)
                    }else{
                        NSNotificationCenter.defaultCenter().postNotificationName("AddGuestSuccess", object: nil)
                    }
                })
                
            }else{
                
                NSNotificationCenter.defaultCenter().postNotificationName("AddGuestError", object: nil)
            }

        }
        
        
        
    }
}
