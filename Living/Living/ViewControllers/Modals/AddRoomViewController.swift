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
import SwiftHUEColorPicker

class AddRoomViewController: UIViewController, SwiftHUEColorPickerDelegate {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var btn_add: UIButton!
    @IBOutlet weak var picker: SwiftHUEColorPicker!
    
    var color:UIColor?
    
    override func viewDidLoad() {
        picker.delegate = self
        picker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
        picker.type = SwiftHUEColorPicker.PickerType.color
        
        self.color = UIColor("#FFFFFF")
        
    }
    

    
    static let AddRoomError = Notification.Name("AddRoomError")
    static let AddRoomSuccess = Notification.Name("AddRoomSuccess")
    
    @IBAction func AddGuest(_ sender: AnyObject) {
        
        dismiss(animated: true) {
            
            let description = self.txt_email.text
            
            
            
            let room = Room(room: description!)
            room.color = self.toHexString(color: self.color!)
            room.save(ArSmartApi.sharedApi.getToken(),hub: ArSmartApi.sharedApi.hub!.hid, completion: { (IsError, result) in
                if(IsError){
                    NotificationCenter.default.post(name:AddRoomViewController.AddRoomError, object: nil)
                }else{
                    NotificationCenter.default.post(name:AddRoomViewController.AddRoomSuccess, object: nil)
                }
            })
        }
        

            

        
    }
    func valuePicked(_ color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        self.color = color;
    }
    func toHexString(color:UIColor) -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}
