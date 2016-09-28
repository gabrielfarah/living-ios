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
    
    static let AddGuestErrorNotification = Notification.Name("AddGuestError")
    static let AddGuestSuccessNotification = Notification.Name("AddGuestSuccess")
    
    
    @IBAction func AddGuest(_ sender: AnyObject) {
        
        dismiss(animated: true) {
            let email = self.txt_email.text
            
            if(ArSmartUtils.isValidEmail(email!)){
                
                let guest = Guest(email: email!)
                guest.save(ArSmartApi.sharedApi.getToken(),hub: ArSmartApi.sharedApi.hub!.hid, completion: { (IsError, result) in
                    if(IsError){
                        NotificationCenter.default.post(name:AddGuestViewController.AddGuestErrorNotification, object: nil)
                    }else{
                        NotificationCenter.default.post(name:AddGuestViewController.AddGuestSuccessNotification, object: nil)
                    }
                })
                
            }else{
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "AddGuestError"), object: nil)
            }

        }
        
        
        
    }
}
