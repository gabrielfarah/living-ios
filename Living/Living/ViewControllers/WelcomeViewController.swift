//
//  WelcomeViewController.swift
//  Living
//
//  Created by Nelson FB on 28/06/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation

import UIKit
import EZLoadingActivity

class WelcomeViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var btn_continue: UIButton!
    
    
    
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
}
