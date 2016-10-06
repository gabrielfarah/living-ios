//
//  DomuAlertViewController.swift
//  Living
//
//  Created by Nelson FB on 28/09/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class DomuAlertViewController: UIViewController {

    
    
    @IBOutlet weak var lbl_message: UILabel!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_ok: UIButton!
    
    var f: ((Bool, String) -> Void)!
    var delegate:DomuAlertViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func setText(text:String){
        lbl_message.text = text
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func ok_action(_ sender: AnyObject) {
        delegate?.DomuAlert_OK()
    }
    @IBAction func cancel_action(_ sender: AnyObject) {
        delegate?.DomuAlert_Cancel()
    }


}

protocol DomuAlertViewControllerDelegate {
    // protocol definition goes here
    func DomuAlert_OK()
    func DomuAlert_Cancel()
    
}

