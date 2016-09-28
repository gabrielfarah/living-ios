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
    
    @IBAction func RegisterHubSerial(_ sender: AnyObject) {
        
        
        if(txt_serial.text!.isEmpty){


            let width = ModalSize.custom(size: 240)
            let height = ModalSize.custom(size: 130)
            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
            
            presenter2.transitionType = .crossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            
            vc2.setText("Debe ingresar un número serial")

            return
        }
        
        
            let parameters: [String: String] = [
                "custom_name" : ArSmartApi.sharedApi.hub!.name,
                "serial" : txt_serial.text!,
                ]
            
         
            let headers = [
                "Authorization": "JWT "+ArSmartApi.sharedApi.getToken(),
                "Accept": "application/json"
            ]
            
        Alamofire.request(ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CreateHub),method:.post,parameters:parameters,encoding: JSONEncoding.default, headers:headers)
                .validate()
                .responseJSON { response  in
                    switch response.result {
                        
                    case .success:
                        
                        print(response.response)
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                        }
                        // Perfom segue
                        
                        self.performSegue(withIdentifier: "SuccessHubRegister", sender: nil)
                    case .failure:
                        //completion(result: "Not Ok")
                        let data = NSData(data: response.data!) as Data
                        var json = JSON(data: data)
                        print("Error")
                        
                            let response_string = (json["ERROR"]).rawString()
                        
                            let width = ModalSize.custom(size: 240)
                            let height = ModalSize.custom(size: 130)
                            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                        
                            presenter2.transitionType = .crossDissolve // Optional
                            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)

                            vc2.setText(response_string!)
                        
                        
                        
                    }
                    
                    
            }
            

        
    }
}
