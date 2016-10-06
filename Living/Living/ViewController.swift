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
    
    
    
    /**
        View Did Load Function, inherith method from UIView
     Controller.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btn_login.isHidden = true
        btn_registrarse.isHidden = true

        // Función de estilo
        style()
        
    }
    /**
     didReceiveMemoryWarning Function, inherith method from UIView
     Controller.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     viewWillAppear Function, inherith method from UIView
     Controller.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                self.navigationController?.isNavigationBarHidden = true
    }
    
    /**
     viewDidAppear Function, inherith method from UIView
     Controller.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // SI está logueado por favor vaya a la vista con el identificador userLoggeIn
        if ArSmartApi.sharedApi.isLoggedIn(){
            performSegue(withIdentifier: "userLoggedIn", sender: nil)
        }else{
            // SI no está logueado por favor muestre en pantalla los botones de Registro y login
            btn_registrarse.isHidden = false
            btn_login.isHidden = false
        }


    }
    /**
     Metodo que aplica los estilos a la vista actual
     */
    func style(){
    
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController!.navigationBar.barTintColor = UIColor("#2CC2BE")
        btn_registrarse.layer.borderColor = UIColor("#D1D3D4").cgColor
        btn_registrarse.layer.borderWidth = 1.0
        btn_registrarse.layer.cornerRadius = 5.0
        btn_login.layer.borderColor = UIColor("#D1D3D4").cgColor
        btn_login.layer.borderWidth = 1.0
        btn_login.layer.cornerRadius = 5.0
        
    }
    
    
    /**
     Metodo Acción que ejecuta cuando se presiona el botón de registro
     */
    @IBAction func TouchRegister(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Living", message:
            "Registrarse!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    /**
     Metodo Acción que ejecuta cuando se presiona el botón de login
     */
    @IBAction func TouchLogin(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Living", message:
            "Iniciar Sesión!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
   
    /**
     Metodo Acción que ejecuta cuando se presiona el botón de saltar: No se utiliza actualmebte
     */
    @IBAction func TouchSkip(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Living", message:
            "Saltar y explorar!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

}

