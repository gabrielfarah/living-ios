//
//  RecoverPassword.swift
//  Living
//
//  Created by Nelson FB on 6/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation

import UIKit
import EZLoadingActivity
import UIKit
import Alamofire
import SwiftyJSON
import Presentr

class RecoverPassword: UIViewController {
    
    
    @IBOutlet weak var txt_email: UITextField!
    
    
    @IBOutlet weak var btn_continue: UIButton!
    
    
    @IBOutlet weak var btn_back: UIButton!
    
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
        btn_continue.layer.borderColor = UIColor(rgba:"#D1D3D4").CGColor
        btn_continue.layer.borderWidth = 1.0
        btn_continue.layer.cornerRadius = 5.0
        
    }
    
    @IBAction func RecoverPassword(sender: AnyObject) {
        
        
        
        User.RecoverPassword(txt_email.text!) { (IsError, result) in
            if(IsError){
            
                let presenter2 = Presentr(presentationType: .Alert)
                
                presenter2.transitionType = .CrossDissolve // Optional
                let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                vc2.lbl_mensaje.text =  result
            
            }else{
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        


        
    }
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
