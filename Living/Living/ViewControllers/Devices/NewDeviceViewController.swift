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
        
        self.navigationController?.navigationBarHidden = true

        
    }

    @IBAction func Close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            
        }
        
    }

    @IBAction func AddZWave(sender: AnyObject) {
        
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        
        let width = ModalSize.Custom(size: 240)
        let height = ModalSize.Custom(size: 130)
        let presenter = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
        
        presenter.transitionType = .CrossDissolve // Optional
        presenter.dismissOnTap = false
        let vc = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
        vc.lbl_menssage.text = "Buscando dispositivos ZWave , un momento por favor..."
        
        ArSmartApi.sharedApi.device_manager.RequestAddZWaveToken(token, hub: hub!) {
            (IsError, result, devices) in
            self.dismissViewControllerAnimated(true, completion: {
                
                
                if(IsError){
                    

                    let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
                    
                    presenter2.transitionType = .CrossDissolve // Optional
                    presenter2.dismissOnTap = true
                    let vc = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc, animated: true, completion: nil)
                    vc.setText("No se encontraron dispositivos ZWave conectados, en caso de que sea un error por favor vuelva a intentarlo")
                    
                    
                }else{
                    self.endpoints = devices
                    self.performSegueWithIdentifier("ShowMeDevices", sender: nil)
                    
                }
                
            })
        }
        
        
    }
    @IBAction func AddWifi(sender: AnyObject) {
        

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
        vc.lbl_menssage.text = "Buscando dispositivos Wifi, un momento por favor..."
        
        
        
        ArSmartApi.sharedApi.device_manager.RequestAddWifiToken(token, hub: hub!) { (IsError, result, devices) in
            
            self.dismissViewControllerAnimated(true, completion: {

                if(IsError){
                    

                    let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
                    
                    presenter2.transitionType = .CrossDissolve // Optional
                    presenter2.dismissOnTap = true
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)

                    vc2.setText("No se encontraron dispositivos Wifi conectados, en caso de que sea un error por favor vuelva a intentarlo")
                    
                    
                }else{
                    self.endpoints = devices
                    self.performSegueWithIdentifier("ShowMeDevices", sender: nil)
                    
                }
                
            })
           

        }
        
        
    }
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ShowMeDevices") {
            // pass data to next view
            let destinationVC = segue.destinationViewController as! FoundDevicesViewController
            destinationVC.endpoints = self.endpoints
        
        }
    }
    
}
