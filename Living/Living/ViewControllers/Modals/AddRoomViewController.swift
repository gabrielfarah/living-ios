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
    
    static let AddRoomError = Notification.Name("AddRoomError")
    static let AddRoomSuccess = Notification.Name("AddRoomSuccess")
    
    @IBAction func AddGuest(_ sender: AnyObject) {
        
        dismiss(animated: true) {
            
            let description = self.txt_email.text
            
            
            
            let room = Room(room: description!)
            room.save(ArSmartApi.sharedApi.getToken(),hub: ArSmartApi.sharedApi.hub!.hid, completion: { (IsError, result) in
                if(IsError){
                    NotificationCenter.default.post(name:AddRoomViewController.AddRoomError, object: nil)
                }else{
                    NotificationCenter.default.post(name:AddRoomViewController.AddRoomSuccess, object: nil)
                }
            })
        }
        

            

        
    }
}
