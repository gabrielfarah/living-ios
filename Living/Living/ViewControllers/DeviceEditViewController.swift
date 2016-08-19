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

class DeviceEditViewController: UIViewController {
    
    
    
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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RoomSelectedNotification), name:"RoomSelected", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SelectIconNewDeviceNotification), name:"SelectIconNewDevice", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddGuest(sender: AnyObject) {
    }
    
    func style(){
        view_border_image.layer.cornerRadius = 5
    }
    func load_info(){
        
        txt_name.text = endpoint.name
        img_device.image = UIImage(named: endpoint.ImageNamed())
    
    }

    @IBAction func save(sender: AnyObject) {
        
        
        
        let is_favorite:Bool = switch_favorite.on
        
        endpoint.favorite = (is_favorite) ? 1 : 0
        
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        //let presenter = Presentr(presentationType: .Alert)
        let width = ModalSize.Custom(size: 240)
        let height = ModalSize.Custom(size: 130)
        let presenter = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
        
        presenter.transitionType = .CrossDissolve // Optional
        presenter.dismissOnTap = false
        let vc = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
        vc.lbl_menssage.text = "Guardando dispositivo en el hub, un momento por favor..."

        
        
        
        if(isNewEndpoint){
            endpoint.Create(hub!, token: token, completion: { (IsError, result) in
                
                
                self.dismissViewControllerAnimated(true, completion: {
                    let width = ModalSize.Custom(size: 240)
                    let height = ModalSize.Custom(size: 130)
                    let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
                    
                    presenter2.transitionType = .CrossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    
                    
                    
                    if(!IsError){
                        
                        vc2.setText("Se agrego con éxito el dispositivo")
                    }else{
                        vc2.setText(String(format:"Ocurrió un error: %@", result))
            
                    }
                    
                    
                })
                

            })

        }else{
            endpoint.Update(hub!, token: token, completion: { (IsError, result) in
                if(IsError){
                
                }else{
                
                
                }
            })
        }

        
    }
    @IBAction func gosetIcon(sender: AnyObject) {
    }
    @IBAction func goSetArea(sender: AnyObject) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ShowSetRoom") {
            // pass data to next view
            let destinationVC = segue.destinationViewController as! RoomsViewController
            destinationVC.is_for_selection = true
        }
    }

    
    func RoomSelectedNotification(notification: NSNotification){
        
        let selected_room = notification.object as! Room
        lbl_room_name.text = selected_room.description
        self.endpoint.room = selected_room
        self.endpoint.is_room_available = true
        
    }
    func SelectIconNewDeviceNotification(notification: NSNotification){
        
        let image:String = notification.object as! String
        
        img_icon.image = UIImage(named:image)!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        img_icon.tintColor = ThemeManager.init().GetUIColor("#2CC2BE")
        
        //var selected_room = notification.object as! Room
        self.endpoint.image = image
        
        
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
    
    
}
