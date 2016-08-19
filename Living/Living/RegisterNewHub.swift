//
//  RegisterNewHub.swift
//  Living
//
//  Created by Nelson FB on 5/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Presentr


class RegisterNewHub:UIViewController {



    @IBOutlet weak var btn_register: UIButton!
    @IBOutlet weak var txt_serial: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        style();
        
        ArSmartApi.sharedApi.token?.CheckTokenAuto()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style(){}
    
    @IBAction func RegisterHubSerial(sender: AnyObject) {
        
        
        if(txt_serial.text!.isEmpty){

            let presenter2 = Presentr(presentationType: .Alert)
            
            presenter2.transitionType = .CrossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            vc2.lbl_mensaje.text =  "Debe ingresar un número serial"

            return
        }
        
        
            let parameters: [String: AnyObject] = [
                "custom_name" : ArSmartApi.sharedApi.hub!.name,
                "serial" : txt_serial.text!,
                ]
            
         
            let headers = [
                "Authorization": "JWT "+ArSmartApi.sharedApi.getToken(),
                "Accept": "application/json"
            ]
            
            Alamofire.request(.POST,ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CreateHub),parameters:parameters,encoding: .JSON, headers:headers)
                .validate()
                .responseJSON { response  in
                    switch response.result {
                        
                    case .Success:
                        
                        print(response.response)
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                        }
                        // Perfom segue
                        
                        self.performSegueWithIdentifier("SuccessHubRegister", sender: nil)
                    case .Failure:
                        //completion(result: "Not Ok")
                        let data = NSData(data: response.data!)
                        var json = JSON(data: data)
                        print("Error")
                        
                            let response_string = (json["ERROR"]).rawString()
                            let presenter2 = Presentr(presentationType: .Alert)
                            
                            presenter2.transitionType = .CrossDissolve // Optional
                            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                            vc2.lbl_mensaje.text =  response_string
                        
                        
                        
                    }
                    
                    
            }
            

        
    }
}
