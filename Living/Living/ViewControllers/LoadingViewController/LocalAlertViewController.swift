//
//  AlertViewController.swift
//  Living
//
//  Created by Nelson FB on 6/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class LocalAlertViewController: UIViewController {

    @IBOutlet weak var lbl_mensaje: UILabel!
    
    var delegate: LocalAlertViewControllerDelegate?
    
    var message:String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbl_mensaje.text = message
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setText(_ text:String){
      
        message = text
    
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dismiss(_ sender: AnyObject) {
        
        self.dismiss(animated: true) {
            
          
            self.delegate?.DismissAlert()
            
            
        }
    }

}
protocol LocalAlertViewControllerDelegate {
    // protocol definition goes here
    func DismissAlert()
    
    
}
