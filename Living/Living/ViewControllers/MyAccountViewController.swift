//
//  MyAccountViewController.swift
//  Living
//
//  Created by Nelson FB on 9/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import UIKit

class MyAccountViewController:UIViewController{

    @IBOutlet weak var btn_add_users: UIButton!

    @IBOutlet weak var btn_change_password: UIButton!

    @IBOutlet weak var btn_logout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    @IBAction func Logout(sender: AnyObject) {
        
        ArSmartApi.sharedApi.Logout()
        //TODO:return to login
        self.parentViewController?.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
   
    
    func style(){
    
        //TODO: Aplica estilos a boton permisos
        //TODO: Aplicar estilos a boton change password
        //TODO: Aplicar estilos a logout
    
    }
    
    

}