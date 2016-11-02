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
    
    var play:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        // Do any additional setup after loading the view.
        slider_volume.minimumValue = MIN_VALUE
        slider_volume.maximumValue = MAX_VALUE
        
        slider_volume.isContinuous = false
        self.lbl_playlist.text = "Cargando..."
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
 
        super.viewDidAppear(animated)
        load_play_list()
        
    
    }
    
    func style(){
    
        let origImage = UIImage(named: "play");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btn_play.setImage(tintedImage, for: UIControlState())
        btn_play.tintColor = UIColor.white
        
        let origImage2 = UIImage(named: "skip_to_start");
        let tintedImage2 = origImage2?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btn_prev.setImage(tintedImage2, for: UIControlState())
        btn_prev.tintColor = UIColor.white
        
        let origImage3 = UIImage(named: "end");
        let tintedImage3 = origImage3?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btn_next.setImage(tintedImage3, for: UIControlState())
        btn_next.tintColor = UIColor.white
        
        

        //image = theImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        //theImageView.tintColor = UIColor.redColor()
    }
    
    func load_play_list(){
        
        //TODO: Cargar la listal sonos
        /*endpoint.GetPlayListSonos { (IsError, result) in
            if(IsError){
            
            }else{
                self.lbl_playlist.text = result
            }
        }*/
        endpoint.GetInfoSonos{ (IsError, result, info) in
            if(IsError){
                
            }else{
                
                if info == nil{
                    return
                }
                //self.lbl_playlist.text = result

                
                 self.slider_volume.setValue(Float((info?.volume)!), animated: true)
                
                self.lbl_playlist.text = info?.current_track["title"]
                //if (playerstate == "PLAYING" or playerstate == "STOPPED" or playerstate == "PAUSED_PLAYBACK") then
                
                if info?.state == "PLAYING"{
                    
                    let origImage = UIImage(named: "pause");
                    let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    self.btn_play.setImage(tintedImage, for: UIControlState())
                    self.btn_play.tintColor = UIColor.white
                
                }else if info?.state == "STOPPED"{
                    
                    let origImage = UIImage(named: "play");
                    let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    self.btn_play.setImage(tintedImage, for: UIControlState())
                    self.btn_play.tintColor = UIColor.white
                
                }else{
                    let origImage = UIImage(named: "play");
                    let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    self.btn_play.setImage(tintedImage, for: UIControlState())
                    self.btn_play.tintColor = UIColor.white
                }
                
                Timer.after(2.seconds, {
                    self.load_play_list()
                })
                
                
            }
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
    @IBAction func Prev(_ sender: AnyObject) {
        


        
        
        endpoint.prevSonos(hub!, token: token, parameters: [:]) { (IsError, result) in
            if(IsError){
                    print("Played Error")
            }else{
                    print("Player Success")
            }
        }
    }
    @IBAction func Play(_ sender: AnyObject) {

        
        play = (play == true) ? false : true
        
        if(!play){
            endpoint.playSonos(hub!, token: token, parameters: [:]) { (IsError, result) in
                if(IsError){
                    print("Played Error")
                }else{
                    print("Player Success")
                    self.load_play_list()
                }
            }
        
        }else{
            endpoint.pauseSonos(hub!, token: token, parameters: [:]) { (IsError, result) in
                if(IsError){
                    print("Played Error")
                }else{
                    print("Player Success")
                    self.load_play_list()
                }
            }
        }

        
    }
    @IBAction func Next(_ sender: AnyObject) {

        endpoint.nextSonos(hub!, token: token, parameters: [:]) { (IsError, result) in
            if(IsError){
                print("Played Error")
            }else{
                print("Player Success")
                self.load_play_list()
            }
        }
        
    }
    @IBAction func ValueChange(_ sender: AnyObject) {

        let volume = ["volume":String(Int(slider_volume.value))]
        
        
        endpoint.setVomuneSonos(hub!, token: token, parameters: volume as [String : AnyObject]) { (IsError, result) in
            if(IsError){
                print("Played Error")
            }else{
                print("Player Success")
                self.load_play_list()
            }
        }
        
    }

}
