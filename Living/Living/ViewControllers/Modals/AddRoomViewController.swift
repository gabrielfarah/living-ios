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


class AddRoomViewController: UIViewController {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var btn_add: UIButton!
    
    
    
    @IBAction func AddGuest(sender: AnyObject) {
        
        dismissViewControllerAnimated(true) {
            
            let description = self.txt_email.text
            
            
            
            let room = Room(room: description!)
            room.save(ArSmartApi.sharedApi.getToken(),hub: ArSmartApi.sharedApi.hub!.hid, completion: { (IsError, result) in
                if(IsError){
                    NSNotificationCenter.defaultCenter().postNotificationName("AddRoomError", object: nil)
                }else{
                    NSNotificationCenter.defaultCenter().postNotificationName("AddRoomSuccess", object: nil)
                }
            })
        }
        

            

        
    }
}
