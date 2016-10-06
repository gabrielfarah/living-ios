//
//  RecoverPassword.swift
//  Living
//
//  Created by Nelson FB on 6/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation

import UIKit
import UIKit
import Alamofire
import SwiftyJSON
import Presentr

class RecoverPassword: UIViewController {
    
    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var btn_continue: UIButton!
    @IBOutlet weak var btn_back: UIButton!
    
    /**
     Inherit method from UIView Controller

     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        style();

    }
    /**
     Inherit method from UIView Controller
     
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     Metodo que aplica los estilos a la vista actual
     
     */
    func style(){
        
        self.navigationController?.isNavigationBarHidden = true
        btn_continue.layer.borderColor = UIColor("#D1D3D4").cgColor
        btn_continue.layer.borderWidth = 1.0
        btn_continue.layer.cornerRadius = 5.0
    }
    /**
     Metodo que ejecuta la acción de recuperar contraseña.
        - parameter sender: El objeto que invoca la acción.
     
     */
    @IBAction func RecoverPassword(_ sender: AnyObject) {
        
        User.RecoverPassword(txt_email.text!) { (IsError, result) in
            if(IsError){
            
                let presenter2 = Presentr(presentationType: .alert)
                
                presenter2.transitionType = .crossDissolve // Optional
                let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                vc2.lbl_mensaje.text =  result
            
            }else{
            
                _ = self.navigationController?.popViewController(animated: true)
            }
        }

    }
    /**
     Metodo que ejecuta la acción de volver a la anterior vista
     - parameter sender: El objeto que invoca la acción.
     
     */
    @IBAction func goBack(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
}
