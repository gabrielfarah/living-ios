//
//  NewUserViewController.swift
//  Living
//
//  Created by Nelson FB on 26/06/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//
import UIKit
import Foundation
import Presentr
import Navajo_Swift


class NewUserViewController: UIViewController {
    

    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_repeat_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var btn_new_account: UIButton!
    @IBOutlet weak var btn_have_account: UIButton!
    
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // style();

        

        
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
        
        
        self.title = "Nueva Cuenta"
        let backButton = UIBarButtonItem(title: "Home/Return or nohing", style: .Bordered, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        
        self.navigationController?.navigationBarHidden = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        
        btn_new_account.layer.borderColor = UIColor(rgba:"#D1D3D4").CGColor
        btn_new_account.layer.borderWidth = 1.0
        btn_new_account.layer.cornerRadius = 5.0
        
        
        let attrs = [NSUnderlineStyleAttributeName : 1,NSForegroundColorAttributeName : UIColor.whiteColor()]
        let attributedString = NSMutableAttributedString(string:"")
        
        let buttonTitleStr = NSMutableAttributedString(string:"¿Ya tienes una cuenta?", attributes:attrs)
        attributedString.appendAttributedString(buttonTitleStr)
        btn_have_account.setAttributedTitle(attributedString, forState: .Normal)
        
        
    }
    
    func validate_data()->Bool{
        let mName:String = txt_name.text!
        let mEmail:String = txt_email.text!
        let mReEmail:String = txt_email.text!
        let mPassword:String = txt_password.text!
        
        
        if(mName.isEmpty){
            return false;
        }else if(mEmail != mReEmail){
            return false;
        }else if(!isValidEmail(mEmail)){
            return false;
        }else if(!isValidPassword(mPassword)){
            return false;
        }else{
            return true;
        }
        
    
    }
    func isValidPassword(candidate: String) -> Bool {
        let lengthRule = NJOLengthRule(min: 6, max: 24)
        let uppercaseRule = NJORequiredCharacterRule(preset: .LowercaseCharacter)
        
        let validator = NJOPasswordValidator(rules: [lengthRule, uppercaseRule])
        
        let failingRules = validator.validatePassword(candidate)
        if failingRules == nil {
            return true
        }else{
            return false
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    @IBAction func HaveAnAccount(sender: AnyObject) {
        


        

        
        
    }

    @IBAction func RegisterUser(sender: AnyObject) {
        
        
        
        if(validate_data()){
            
            let presenter = Presentr(presentationType: .Alert)
            
            presenter.transitionType = .CrossDissolve // Optional
            let vc = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
            customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
            
            
            
            //Hace la conexión
            let mName:String = txt_name.text!
            let mEmail:String = txt_email.text!
            let mPassword:String = txt_password.text!
            
            ArSmartApi.sharedApi.RegisterUser(mEmail, name: mName, password: mPassword){
                (IsError:Bool,result: String) in
                
                
                self.dismissViewControllerAnimated(true, completion: {
                    if(IsError){
                        
                        
                        
                        
                        let presenter2 = Presentr(presentationType: .Alert)
                        
                        presenter2.transitionType = .CrossDissolve // Optional
                        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                        vc2.lbl_mensaje.text = result
                        
                    }else{
                        
                        ArSmartApi.sharedApi.token?.user = mEmail
                        ArSmartApi.sharedApi.token?.password = mPassword
                        
                        
                        self.performSegueWithIdentifier("WelcomeSegue", sender: nil)
                        
                        
                        
                    }
                })
                


                
                
                
            }
            
            
        }else{
            // Muestra error de datos
            
            let alert = UIAlertController(title: "Living", message: "Error en el registro de datos", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    print("default")
                    
                case .Cancel:
                    print("cancel")
                    
                case .Destructive:
                    print("destructive")
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
        
    }

    @IBAction func goback(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
  

}