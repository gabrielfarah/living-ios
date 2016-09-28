//
//  CongratulationsViewController.swift
//  Living
//
//  Created by Nelson FB on 6/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import UIKit


class CongratulationsViewController: UIViewController {
    
    
    
    
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
        
        self.navigationController?.isNavigationBarHidden = true

    }
}
