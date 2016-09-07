//
//  LoginViewController.swift
//  Living
//
//  Created by Nelson FB on 26/06/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import UIKit
import Presentr

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_forgot: UIButton!
    @IBOutlet weak var btn_no_account: UIButton!
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // style();
        ArSmartApi.sharedApi.Logout()
        
       // txt_email.text = ""
        //txt_password.text = ""
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        style();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style(){
        
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    
        self.title = "Ingresar en su cuenta"
        let backButton = UIBarButtonItem(title: "Home/Return or nohing", style: .Bordered, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.navigationBarHidden = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        

            

            btn_login.layer.borderColor = UIColor(rgba:"#D1D3D4").CGColor
            btn_login.layer.borderWidth = 1.0
            btn_login.layer.cornerRadius = 5.0
            
        
        
        
        
    }
    @IBAction func Login(sender: AnyObject) {
        
        let width = ModalSize.Custom(size: 240)
        let height = ModalSize.Custom(size: 130)
        let presenter = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
        
        presenter.transitionType = .CrossDissolve // Optional
        presenter.dismissOnTap = false
        let vc = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
        vc.lbl_menssage.text = "Autenticando, un momento por favor..."
        let mPassword:String = txt_password.text!
        let mEmail:String = txt_email.text!

        ArSmartApi.sharedApi.user.Login(mEmail, password: mPassword) { (IsError, result) in
            if(IsError){
                
                self.dismissViewControllerAnimated(true, completion: {
                    let width = ModalSize.Custom(size: 240)
                    let height = ModalSize.Custom(size: 130)
                    let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
                    
                    presenter2.transitionType = .CrossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)

                    vc2.setText(result)
                })
                
            }else{
                ArSmartApi.sharedApi.token!.user = mEmail
                ArSmartApi.sharedApi.token!.user = mPassword
                self.dismissViewControllerAnimated(true, completion: {
                    //self.performSegueWithIdentifier("GoLogin", sender: nil)
                    self.performSegueWithIdentifier("userLogged", sender: nil)
                    
                })
            }
        }

    }
}