//
//  ViewController.swift
//  Living
//
//  Created by Nelson FB on 21/06/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class ViewController: UIViewController {


    @IBOutlet weak var btn_registrarse: UIButton!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_skip: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ArSmartApi.sharedApi.PrintTest()

        
        style()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                self.navigationController?.navigationBarHidden = true
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        


    }
    
    func style(){
    
        self.navigationController?.navigationBarHidden = true
        self.navigationController!.navigationBar.barTintColor = UIColor(rgba:"#2CC2BE")
        
        btn_registrarse.layer.borderColor = UIColor(rgba:"#D1D3D4").CGColor
        btn_registrarse.layer.borderWidth = 1.0
        btn_registrarse.layer.cornerRadius = 5.0
        
        btn_login.layer.borderColor = UIColor(rgba:"#D1D3D4").CGColor
        btn_login.layer.borderWidth = 1.0
        btn_login.layer.cornerRadius = 5.0
        

    
    }
    
    

    @IBAction func TouchRegister(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Living", message:
            "Registrarse!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    @IBAction func TouchLogin(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Living", message:
            "Iniciar Sesión!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
   
    @IBAction func TouchSkip(sender: AnyObject) {
        let alertController = UIAlertController(title: "Living", message:
            "Saltar y explorar!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

