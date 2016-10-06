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
import Localize_Swift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_forgot: UIButton!
    @IBOutlet weak var btn_no_account: UIButton!
    
    
    /**
     viewDidLoad, Inheriht method from UIViewController
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    /**
     viewWillAppear, Inheriht method from UIViewController
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        style();
        
    }
    /**
     didReceiveMemoryWarning, Inheriht method from UIViewController
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     Metodo que permite aplicar los estilos a la vista actual
     */
    func style(){
        
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    
        self.title = "Ingresar en su cuenta".localized()
        let backButton = UIBarButtonItem(title: "Home/Return or nohing", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        btn_login.layer.borderColor = UIColor("#D1D3D4").cgColor
        btn_login.layer.borderWidth = 1.0
        btn_login.layer.cornerRadius = 5.0
        
    }
    
    /**
     Metodo que ejecuta la acción de login.
     
     - parameter sender: Objeto que envía la acción en este caso el boton.
     
     */
    @IBAction func Login(_ sender: AnyObject) {
        
        let width = ModalSize.custom(size: 240)
        let height = ModalSize.custom(size: 130)
        let presenter = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
        
        presenter.transitionType = .crossDissolve // Optional
        presenter.dismissOnTap = false
        let vc = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
        vc.setText("Autenticando, un momento por favor...".localized())
        let mPassword:String = txt_password.text!
        let mEmail:String = txt_email.text!

        ArSmartApi.sharedApi.user.Login(mEmail, password: mPassword) { (IsError, result) in
            if(IsError){
                
                self.dismiss(animated: true, completion: {
                    let width = ModalSize.custom(size: 240)
                    let height = ModalSize.custom(size: 130)
                    let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                    
                    presenter2.transitionType = .crossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)

                    vc2.setText(result)
                })
                
            }else{
                ArSmartApi.sharedApi.token!.user = mEmail
                ArSmartApi.sharedApi.token!.user = mPassword
                self.dismiss(animated: true, completion: {
                    //self.performSegueWithIdentifier("GoLogin", sender: nil)
                    self.performSegue(withIdentifier: "userLogged", sender: nil)
                    
                })
            }
        }

    }
}
