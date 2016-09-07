//
//  LevelViewController.swift
//  Living
//
//  Created by Nelson FB on 17/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {

    let MIN_VALUE:Float = 0
    let MAX_VALUE:Float = 99
    
    var endpoint:Endpoint = Endpoint()
    var delegate:LevelViewControllerDelegate?
    
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var slider_level: UISlider!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slider_level.minimumValue = MIN_VALUE
        slider_level.maximumValue = MAX_VALUE
        
        slider_level.continuous = false
        
        // Do any additional setup after loading the view.
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
    @IBAction func sliderMoved(sender: AnyObject) {
        
        //TODO: hacer el llamado
        
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        
        delegate?.ValueChanged(slider_level.value)
        //TODO:SetValue
        
        let value = String(Int(slider_level.value))
        print("Value Changed: ",Int(slider_level.value) )
        
        endpoint.setValue(hub!, token: token, value: value) { (IsError, result) in
            print("Change Value")
            if(IsError){
                print("Set Command Error")
            }else{
                print("Set Command Success")
            }
        }
        
        
    }

    
}
protocol LevelViewControllerDelegate {
    // protocol definition goes here
    func ValueChanged(value:Float)
    
}
