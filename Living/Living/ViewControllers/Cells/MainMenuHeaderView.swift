//
//  MainMenuHeaderView.swift
//  Living
//
//  Created by Nelson FB on 1/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation

import UIKit
import EZLoadingActivity
import Photos


class MainMenuHeaderView: UIViewController  {

    

    @IBOutlet weak var view_main: UIView!
    
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
        
        view_main.layer.cornerRadius = 30.0
    }


}
