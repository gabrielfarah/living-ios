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
import Localize_Swift

class RegisterRouterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, LocalAlertViewControllerDelegate {

    
    var tzs:[String] = [String]()
    var selected_tz:String = ""
    let endpoint = "http://192.168.42.1:8080/"
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "http://192.168.42.1:8080/")
    var isReachable:Bool = false
    
    @IBOutlet weak var txt_timezone: UITextField!
    @IBOutlet weak var txt_ssid: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var btn_register: UIButton!
    @IBOutlet weak var btn_cancelar: UIButton!
    
    @IBOutlet weak var picker_view_list: UIPickerView!
    

    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        init_tz()
        txt_timezone.inputView = picker_view_list
        
        

        
        func listenForReachability() {
            self.reachabilityManager?.listener = { status in
                print("Network Status Changed: \(status)")
                switch status {
                case .notReachable:
                     self.isReachable = false
                    break
                //Show error state
                case .reachable(_), .unknown:
                    self.isReachable = true
                    break
                    //Hide error state
                }
            }
            
            self.reachabilityManager?.startListening()
        }

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func init_tz(){
        let tzs_dict:[String:String] = NSTimeZone.abbreviationDictionary

        
        for (_, value) in tzs_dict {
            tzs.append(value)
        }
        print(tzs)
    
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
        
        
        // Esto esta generando error
        if !isReachable {
            let width = ModalSize.custom(size: 240)
            let height = ModalSize.custom(size: 130)
            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
            
            presenter2.transitionType = .crossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
//self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            
            vc2.setText("Can not connect to Hub, please try again".localized())
            
            
            let tracker = GAI.sharedInstance().defaultTracker
            let eventTracker: NSObject = GAIDictionaryBuilder.createException(withDescription: "The IP is not reachable".localized(), withFatal: false).build()
            tracker?.send(eventTracker as! [NSObject : AnyObject])
            
            //return

            
        }
        
        
        if txt_ssid.text == "" {
            
            let width = ModalSize.custom(size: 240)
            let height = ModalSize.custom(size: 130)
            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
            
            presenter2.transitionType = .crossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            
            vc2.setText("The SSID can not be empty".localized())
        
            return
        }
        
        if txt_timezone.text == "" {
            
            let width = ModalSize.custom(size: 240)
            let height = ModalSize.custom(size: 130)
            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
            
            presenter2.transitionType = .crossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            
            vc2.setText("You must choose a time zone".localized())
            
            return
        }
        
        
        
        let parameters: [String: String] = [
            "ssid" : txt_ssid.text!,
            "password" : txt_password.text! ,
            "timezone" : selected_tz ,
            ]
        
        

        
        let width = ModalSize.custom(size: 240)
        let height = ModalSize.custom(size: 130)
        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
        
        presenter2.transitionType = .crossDissolve // Optional
        let vc2 = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
        
        vc2.setText("One moment please...".localized())

        
        
        Alamofire.request(endpoint,method:.post,parameters:parameters,encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    self.dismiss(animated: true, completion: {
                        let width = ModalSize.custom(size: 240)
                        let height = ModalSize.custom(size: 130)
                        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                        
                        presenter2.transitionType = .crossDissolve // Optional
                        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                        
                        vc2.setText("Wait a minute until the internet icon on the front of the device turns green. Once the led turn green, press the continue button on the app.".localized())
                    })
                    break
                //do json stuff
                case .failure(let error):
                    
                    
                    if error._code == NSURLErrorTimedOut {
                        //timeout
                        self.dismiss(animated: true, completion: {
                            let width = ModalSize.custom(size: 240)
                            let height = ModalSize.custom(size: 130)
                            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                            
                            presenter2.transitionType = .crossDissolve // Optional
                            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                            
                            vc2.setText("Please make sure your phone WIFI is active and connected to the 'Domu-AP' network. Also make sure to momentarily deactivate the mobile data in your phone".localized())
                        })
                    }else{
                        self.dismiss(animated: true, completion: {
                            let width = ModalSize.custom(size: 240)
                            let height = ModalSize.custom(size: 130)
                            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                            
                            presenter2.transitionType = .crossDissolve // Optional
                            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                            vc2.delegate = self
                            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                            
                            vc2.setText("Wait a minute until the internet icon on the front of the device turns green. Once the led turn green, press the continue button on the app.".localized())
                        })

                    
                    }
                    

                    
                    break


                    
                    


                    
                    
                }
                
                
                
        }
        
        
    }
    @IBAction func CancelRegistration(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tzs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tzs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected_tz = tzs[row]
        txt_timezone.text = selected_tz
    }
    
    func DismissAlert() {
        sideMenuController?.performSegue(withIdentifier: "showCenterController1", sender: nil)
    }


}
