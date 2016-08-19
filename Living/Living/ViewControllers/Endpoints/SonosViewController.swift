//
//  SonosViewController.swift
//  Living
//
//  Created by Nelson FB on 10/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class SonosViewController: UIViewController {

    
    let MIN_VALUE:Float = 0
    let MAX_VALUE:Float = 99
    
    let token = ArSmartApi.sharedApi.getToken()
    let hub = ArSmartApi.sharedApi.hub?.hid
    var endpoint:Endpoint = Endpoint()
    
    
    @IBOutlet weak var btn_prev: UIButton!
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var lbl_playlist: UILabel!
    @IBOutlet weak var slider_volume: UISlider!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        // Do any additional setup after loading the view.
        slider_volume.minimumValue = MIN_VALUE
        slider_volume.maximumValue = MAX_VALUE
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func style(){
    
        let origImage = UIImage(named: "play");
        let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        btn_play.setImage(tintedImage, forState: .Normal)
        btn_play.tintColor = UIColor.whiteColor()
        
        let origImage2 = UIImage(named: "skip_to_start");
        let tintedImage2 = origImage2?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        btn_prev.setImage(tintedImage2, forState: .Normal)
        btn_prev.tintColor = UIColor.whiteColor()
        
        let origImage3 = UIImage(named: "end");
        let tintedImage3 = origImage3?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        btn_next.setImage(tintedImage3, forState: .Normal)
        btn_next.tintColor = UIColor.whiteColor()
        
        

        //image = theImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        //theImageView.tintColor = UIColor.redColor()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func Prev(sender: AnyObject) {
        


        
        
        endpoint.prevSonos(hub!, token: token, parameters: [:]) { (IsError, result) in
            if(IsError){
                    print("Played Error")
            }else{
                    print("Player Success")
            }
        }
    }
    @IBAction func Play(sender: AnyObject) {

        
        
        
        endpoint.playSonos(hub!, token: token, parameters: [:]) { (IsError, result) in
            if(IsError){
                print("Played Error")
            }else{
                print("Player Success")
            }
        }
        
    }
    @IBAction func Next(sender: AnyObject) {

        
        
        
        endpoint.nextSonos(hub!, token: token, parameters: [:]) { (IsError, result) in
            if(IsError){
                print("Played Error")
            }else{
                print("Player Success")
            }
        }
        
    }
    @IBAction func ValueChange(sender: AnyObject) {

        let volume = ["volume":String(slider_volume.value)]
        
        
        endpoint.setVomuneSonos(hub!, token: token, parameters: volume) { (IsError, result) in
            if(IsError){
                print("Played Error")
            }else{
                print("Player Success")
            }
        }
        
    }

}
