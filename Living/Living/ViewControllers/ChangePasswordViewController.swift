//
//  ChangePasswordViewController.swift
//  Living
//
//  Created by Nelson FB on 19/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import Presentr

class ChangePasswordViewController: UIViewController {

    
    
    @IBOutlet weak var txt_old_password: UITextField!
    @IBOutlet weak var txt_new_password_1: UITextField!
    @IBOutlet weak var txt_new_password_2: UITextField!
    @IBOutlet weak var btn_change_password: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        

        txt_old_password.attributedPlaceholder = NSAttributedString(string:"Antigua contraseña",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.white])
        txt_new_password_1.attributedPlaceholder = NSAttributedString(string:"Antigua contraseña",
                                                                    attributes:[NSForegroundColorAttributeName: UIColor.white])
        txt_new_password_2.attributedPlaceholder = NSAttributedString(string:"Confirmar contraseña",
                                                                      attributes:[NSForegroundColorAttributeName: UIColor.white])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func ChangePassword(_ sender: AnyObject) {
        
        //TODO: Validar si la clave vieja es la verdadera
        //TODO: validar que las claves sean iguales
        //TODO:Luego cambiar
        
        let token = ArSmartApi.sharedApi.getToken()
        if(txt_new_password_1.text == txt_new_password_2.text && txt_new_password_1.text != ""){
            ArSmartApi.sharedApi.user.ChangePassword(token,password_old: txt_old_password.text!, new_password:txt_new_password_1.text!) { (IsError, result) in
                let width = ModalSize.custom(size: 240)
                let height = ModalSize.custom(size: 130)
                let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                
                presenter2.transitionType = .crossDissolve // Optional
                let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                vc2.setText(result)
            }
        }else{
            let width = ModalSize.custom(size: 240)
            let height = ModalSize.custom(size: 130)
            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
            
            presenter2.transitionType = .crossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            vc2.setText("Las contraseñas debe coincidir y no deben ser vacias")
        }
        

        
        
    }

}
