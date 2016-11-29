//
//  GuestsViewController.swift
//  Living
//
//  Created by Nelson FB on 17/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import Presentr
import SideMenuController

class DeviceEditViewController: UIViewController,LocalAlertViewControllerDelegate {
    
    
    
    @IBOutlet weak var lbl_room_name: UILabel!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var img_device: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var btn_icons: UILabel!
    @IBOutlet weak var btn_rooms: UIView!
    @IBOutlet weak var view_border_image: UIView!
    @IBOutlet weak var switch_favorite: UISwitch!
    @IBOutlet weak var img_icon: UIImageView!
    
    
    var isNewEndpoint:Bool = true
    var endpoint = Endpoint()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_info()
        style()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(RoomSelectedNotification), name:NSNotification.Name(rawValue: "RoomSelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SelectIconNewDeviceNotification), name:NSNotification.Name(rawValue: "SelectIconNewDevice"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddGuest(_ sender: AnyObject) {
    }
    
    func style(){
        view_border_image.layer.cornerRadius = 5
    }
    func load_info(){
        
        txt_name.text = endpoint.name
        img_device.image = UIImage(named: endpoint.ImageNamed())
    
    }

    @IBAction func save(_ sender: AnyObject) {
        
        let name:String = txt_name.text!
        
        if name == "" {
            let width = ModalSize.custom(size: 240)
            let height = ModalSize.custom(size: 130)
            let presenter = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
            
            presenter.transitionType = .crossDissolve // Optional
            presenter.dismissOnTap = true
            let vc = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
            vc.setText("The device name cant be empty...".localized())
            return
        }
        
        
        endpoint.favorite = 0
        
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        //let presenter = Presentr(presentationType: .Alert)
        let width = ModalSize.custom(size: 240)
        let height = ModalSize.custom(size: 130)
        let presenter = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
        
        presenter.transitionType = .crossDissolve // Optional
        presenter.dismissOnTap = false
        let vc = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
        vc.setText("Saving device in the hub, one moment please...".localized())
        
        
        
        endpoint.name = name
        
        if(isNewEndpoint){
            endpoint.Create(hub!, token: token, completion: { (IsError, result) in
                
                
                self.dismiss(animated: true, completion: {
                    let width = ModalSize.custom(size: 240)
                    let height = ModalSize.custom(size: 130)
                    let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                    
                    presenter2.transitionType = .crossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    
                    
                    
                    if(!IsError){
                        
                        vc2.setText("Device was sucessfully added".localized())
                        vc2.delegate = self
                        
                        
                        //TODO: Volver al home
                        self.sideMenuController?.performSegue(withIdentifier: "showCenterController1", sender: nil)
                    }else{
                        vc2.setText(String(format:"error: %@".localized(), result))
            
                    }
                    
                    
                })
                

            })

        }else{
            endpoint.Update(hub!, token: token, completion: { (IsError, result) in
                
                self.dismiss(animated: true, completion: {
                    let width = ModalSize.custom(size: 240)
                    let height = ModalSize.custom(size: 130)
                    let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                    
                    presenter2.transitionType = .crossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    vc2.delegate = self
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    
                    
                    
                    if(!IsError){
                        
                        vc2.setText("Device was sucessfully updated.".localized())
                    }else{
                        vc2.setText(String(format:"error: %@".localized(), result))
                        
                    }
                    
                    
                })
            })
        }

        
    }
    @IBAction func gosetIcon(_ sender: AnyObject) {
    }
    @IBAction func goSetArea(_ sender: AnyObject) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "ShowSetRoom") {
            // pass data to next view
            let destinationVC = segue.destination as! RoomsViewController
            destinationVC.is_for_selection = true
        }
    }

    
    func RoomSelectedNotification(_ notification: Notification){
        
        let selected_room = notification.object as! Room
        lbl_room_name.text = selected_room.description
        self.endpoint.room = selected_room
        self.endpoint.is_room_available = true
        
    }
    func SelectIconNewDeviceNotification(_ notification: Notification){
        
        let image:String = notification.object as! String
        
        img_icon.image = UIImage(named:image)!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        img_icon.tintColor = ThemeManager.init().GetUIColor("#2CC2BE")
        
        //var selected_room = notification.object as! Room
        self.endpoint.image = Endpoint.NameImages(name: image) 
        
        
    }
    
    func validate_date()->Bool{
        
        if(lbl_room_name.text == ""){
            return false
        
        }else if (!endpoint.is_room_available){
            return false
        }else{
        
            return true
        }
        
    
    }
    
    func DismissAlert() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}
