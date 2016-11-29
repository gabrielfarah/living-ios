//
//  NewDeviceViewController.swift
//  Living
//
//  Created by Nelson FB on 7/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import Foundation
import Presentr
import Localize_Swift


class NewDeviceViewController: UIViewController {
    

    
    @IBOutlet weak var activity_indicator: UIActivityIndicatorView!
    @IBOutlet weak var btn_update: UIButton!
    @IBOutlet weak var lbl_update: UILabel!
    @IBOutlet weak var btn_back: UIButton!
    
    
    
    
    var endpoints:[EndpointResponse] = [EndpointResponse]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        style();
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style(){
        
        self.navigationController?.isNavigationBarHidden = true

        
    }

    @IBAction func Close(_ sender: AnyObject) {
        self.dismiss(animated: true) {
            
        }
        
    }

    @IBAction func AddZWave(_ sender: AnyObject) {
        
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        
        let width = ModalSize.custom(size: 240)
        let height = ModalSize.custom(size: 130)
        let presenter = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
        
        presenter.transitionType = .crossDissolve // Optional
        presenter.dismissOnTap = false
        let vc = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
        vc.setText("Looking for a Zwave device, one moment please...".localized())
        
        ArSmartApi.sharedApi.device_manager.RequestAddZWaveToken(token, hub: hub!) {
            (IsError, result, devices) in
            self.dismiss(animated: true, completion: {
                
                
                if(IsError){
                    

                    let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                    
                    presenter2.transitionType = .crossDissolve // Optional
                    presenter2.dismissOnTap = true
                    let vc = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc, animated: true, completion: nil)
                    vc.setText("No connected ZWave devices found, in case it is an error please try again".localized())
                    
                    
                }else{
                    self.endpoints = devices
                    self.performSegue(withIdentifier: "ShowMeDevices", sender: nil)
                    
                }
                
            })
        }
        
        
    }
    @IBAction func AddWifi(_ sender: AnyObject) {
        

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
        vc.setText("Searching for Wifi devices, one moment please ...".localized())
        
        
        ArSmartApi.sharedApi.device_manager.RequestAddWifiToken(token, hub: hub!) { (IsError, result, devices) in
            
            self.dismiss(animated: true, completion: {

                if(IsError){
                    

                    let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                    
                    presenter2.transitionType = .crossDissolve // Optional
                    presenter2.dismissOnTap = true
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)

                    vc2.setText("No connected Wifi devices found, in case it is an error please try again".localized())
                    
                    
                }else{
                    self.endpoints = devices
                    self.performSegue(withIdentifier: "ShowMeDevices", sender: nil)
                    
                }
                
            })
           

        }
        
        
    }
    @IBAction func goBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "ShowMeDevices") {
            // pass data to next view
            let destinationVC = segue.destination as! FoundDevicesViewController
            destinationVC.endpoints = self.endpoints
        
        }
    }
    
}
