//
//  RegisterRouterViewController.swift
//  Living
//
//  Created by Nelson FB on 3/10/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import Alamofire
import Presentr

class RegisterRouterViewController: UIViewController {

    

    @IBOutlet weak var txt_ssid: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var btn_register: UIButton!
    @IBOutlet weak var btn_cancelar: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func RegisterHub(_ sender: AnyObject) {
        
        
        let parameters: [String: String] = [
            "ssid" : txt_ssid.text!,
            "password" : txt_password.text! ,
            "timezone" : "America/Los_Angeles" ,
            ]
        
        
        let endpoint = "http://127.0.0.1:8080/"
        
        let width = ModalSize.custom(size: 240)
        let height = ModalSize.custom(size: 130)
        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
        
        presenter2.transitionType = .crossDissolve // Optional
        let vc2 = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
        
        vc2.setText("Un momento por favor...")

        
        
        Alamofire.request(endpoint,method:.post,parameters:parameters,encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                    
                case .success:
                    self.dismiss(animated: true, completion: {
                        let width = ModalSize.custom(size: 240)
                        let height = ModalSize.custom(size: 130)
                        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                        
                        presenter2.transitionType = .crossDissolve // Optional
                        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)

                        vc2.setText("Se configuró con éxito...")
                    })
                    print("success")
                    
                    
                    
                case .failure(let error):
                    self.dismiss(animated: true, completion: {
                        let width = ModalSize.custom(size: 240)
                        let height = ModalSize.custom(size: 130)
                        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                        
                        presenter2.transitionType = .crossDissolve // Optional
                        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                        
                        vc2.setText("Ocurrió un error en la configuración por favor vuelva a intentarlo...")
                    })

                    
                    
                }
                
                
                
        }
        
        
    }
    @IBAction func CancelRegistration(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            
        }
    }


}
