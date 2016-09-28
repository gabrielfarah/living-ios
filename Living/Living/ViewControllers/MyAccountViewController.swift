//
//  MyAccountViewController.swift
//  Living
//
//  Created by Nelson FB on 9/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import UIKit
import UIColor_Hex_Swift

class MyAccountViewController:UIViewController{

    
    var theme = ThemeManager()
    @IBOutlet weak var btn_add_users: UIButton!
    @IBOutlet weak var btn_change_password: UIButton!
    @IBOutlet weak var btn_logout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Account"
        self.navigationController?.navigationBar.barTintColor = UIColor(theme.MainColor)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    @IBAction func Logout(_ sender: AnyObject) {
        
        ArSmartApi.sharedApi.Logout()
        //TODO:return to login
        self.parent?.navigationController?.popToRootViewController(animated: true)
        
    }
    
   
    
    func style(){
    
        //TODO: Aplica estilos a boton permisos
        //TODO: Aplicar estilos a boton change password
        //TODO: Aplicar estilos a logout
    
    }
    
    

}
