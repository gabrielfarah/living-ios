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
import SwiftHUEColorPicker

class DeviceEditViewController: UIViewController,LocalAlertViewControllerDelegate,SwiftHUEColorPickerDelegate, UIPickerViewDelegate,UIPickerViewDataSource{
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    
    
    @IBOutlet weak var lbl_room_name: UILabel!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var img_device: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var btn_icons: UILabel!
    @IBOutlet weak var btn_rooms: UIView!
    @IBOutlet weak var view_border_image: UIView!
    @IBOutlet weak var switch_favorite: UISwitch!
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var view_color: UIView!
    @IBOutlet weak var picker: SwiftHUEColorPicker!
    @IBOutlet weak var view_sig_type: UIView!
    
    @IBOutlet weak var txt_sig_type: UITextField!
    @IBOutlet weak var picker_sig_type: UIPickerView!

    var color:UIColor?
    
    var isNewEndpoint:Bool = true
    var endpoint = Endpoint()

    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_info()
        style()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(RoomSelectedNotification), name:NSNotification.Name(rawValue: "RoomSelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SelectIconNewDeviceNotification), name:NSNotification.Name(rawValue: "SelectIconNewDevice"), object: nil)
        
        picker.delegate = self as SwiftHUEColorPickerDelegate
        
        picker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
        picker.type = SwiftHUEColorPicker.PickerType.color
        
        
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
        
        
        pickerData = ["centigrades", "lux", "kwh", "percent"]
        self.picker_sig_type.delegate = self as UIPickerViewDelegate
        self.picker_sig_type.dataSource = self as! UIPickerViewDataSource
        
       
        txt_sig_type.inputView = picker_sig_type
        txt_name.text = endpoint.name
        img_device.image = UIImage(named: endpoint.ImageNamed())
        
        //endpoint.sig_type = ""
        if endpoint.sig_type == "ui-sensor-multilevel"{
            view_sig_type.isHidden = false
        }else{
            view_sig_type.isHidden = true
        }
    
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
    
    func  valuePicked(_ color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        self.color = color
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
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        endpoint.sig_type = pickerData[row]
    }
    
    
}
