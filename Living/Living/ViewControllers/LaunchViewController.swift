//
//  LaunchViewController.swift
//  Living
//
//  Created by Nelson FB on 30/05/17.
//  Copyright © 2017 ar-smart. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    
    @IBOutlet weak var image_logo: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadCompanyInfo()
        
        
        
    }
    override func viewDidAppear(_ animated:Bool){
        super.viewDidAppear(animated)
        
        _ = Timer.after(5.seconds, {
            self.performSegue(withIdentifier: "GoLogin", sender: self)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadCompanyInfo(){
    
        let color = ArSmartApi.sharedApi.hub?.project_info_color
        let hub = ArSmartApi.sharedApi.hub!;
        
        self.view.backgroundColor = UIColor(color!)
        if hub.project_info_name != "" {
            let url_string = String(format:"https://living.ar-smart.co/media/%@.png",hub.project_info_name)
            let url:NSURL? = NSURL(string: url_string)
            let data:NSData? = NSData(contentsOf : url! as URL)
            
            
            let image = UIImage(data : data! as Data)
            
            
            image_logo.image = image
        }

        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
