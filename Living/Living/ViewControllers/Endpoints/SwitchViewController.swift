//
//  SwitchViewController.swift
//  Living
//
//  Created by Nelson FB on 17/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class SwitchViewController: UIViewController {

    let MIN_VALUE:Int = 0
    let MAX_VALUE:Int = 255
    
    var delegate:SwitchViewControllerDelegate?
    var endpoint:Endpoint = Endpoint()
    

    @IBOutlet weak var swt_control: UISwitch!
    @IBOutlet weak var lbl_name: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)
        turnon()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func turnon(){
        if(endpoint.state == MAX_VALUE){
            swt_control.setOn(true, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func ValueChanged(sender: AnyObject) {
        
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        print("Value Changed:%@",swt_control.on )
        delegate?.ValueChanged(swt_control.on)
        //TODO:SetValue
        
        let value = String((swt_control.on) ? MAX_VALUE : MIN_VALUE)
        
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
protocol SwitchViewControllerDelegate {
    // protocol definition goes here
    func ValueChanged(value:Bool)
    
}
