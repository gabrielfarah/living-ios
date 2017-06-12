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

class AddRoomViewController: UIViewController, SwiftHUEColorPickerDelegate, LocalAlertViewControllerDelegate {
    
    
    static let PostSelectIconRoom = Notification.Name("PostSelectIconRoom")
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var btn_add: UIButton!
    @IBOutlet weak var picker: SwiftHUEColorPicker!
    @IBOutlet weak var btn_icon: UIButton!
    @IBOutlet weak var img_icon: UIImageView!
    
    
    public var room:Room? = Room()
    
    public var forUpdate:Bool = false
    
    var color:UIColor?
    
    override func viewDidLoad() {
        picker.delegate = self
        picker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
        picker.type = SwiftHUEColorPicker.PickerType.color
        
        self.color = UIColor("#FFFFFF")
      
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(SelectIconNewDeviceNotification), name:NSNotification.Name(rawValue: "SelectIconNewDevice"), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if forUpdate{
            self.title = "Editar Habitación".localized()
        }
    }
    

    
    static let AddRoomError = Notification.Name("AddRoomError")
    static let AddRoomSuccess = Notification.Name("AddRoomSuccess")
    
    @IBAction func AddGuest(_ sender: AnyObject) {
        

            
            let description = self.txt_email.text
            
            
            
            room?.description = description!
            room?.color = self.toHexString(color: self.color!)
        
        if forUpdate{
            room?.update(ArSmartApi.sharedApi.getToken(),hub: ArSmartApi.sharedApi.hub!.hid, completion: { (IsError, result) in
                if(IsError){
                    
                    let width = ModalSize.custom(size: 240)
                    let height = ModalSize.custom(size: 120)
                    let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                    
                    presenter2.transitionType = .crossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    
                    vc2.setText("Operation failed, please try again...".localized())
                }else{
                    let width = ModalSize.custom(size: 240)
                    let height = ModalSize.custom(size: 120)
                    let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                    presenter2.transitionType = .crossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    vc2.delegate = self
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    vc2.setText("Room updated succesfully...".localized())
                    
                    
                }
            })
        }else{
            room?.save(ArSmartApi.sharedApi.getToken(),hub: ArSmartApi.sharedApi.hub!.hid, completion: { (IsError, result) in
                if(IsError){
                    
                    let width = ModalSize.custom(size: 240)
                    let height = ModalSize.custom(size: 120)
                    let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                    
                    presenter2.transitionType = .crossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    
                    vc2.setText("Operation failed, please try again...".localized())
                }else{
                    let width = ModalSize.custom(size: 240)
                    let height = ModalSize.custom(size: 120)
                    let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                    presenter2.transitionType = .crossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    vc2.delegate = self
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    vc2.setText("Room added succesfully...".localized())
                    
                    
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
    @IBAction func ChooseIcon(_ sender: Any) {
        NotificationCenter.default.post(name:AddRoomViewController.PostSelectIconRoom, object: nil)
    }
    func SelectIconNewDeviceNotification(_ notification: Notification){
        
        let image:String = notification.object as! String
        
        img_icon.image = UIImage(named:image)!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        img_icon.tintColor = ThemeManager.init().GetUIColor("#2CC2BE")
        
        //var selected_room = notification.object as! Room
        //self.endpoint.image = Endpoint.NameImages(name: image)
        
        self.room?.image = Room.NameImages(name: image)
    }
    
    
    func DismissAlert(){
    _ = self.navigationController?.popViewController(animated: true)
    }
    
}
