//
//  SonosViewController.swift
//  Living
//
//  Created by Nelson FB on 10/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class SensorViewController: UIViewController {
    
    
    let MIN_VALUE:Float = 0
    let MAX_VALUE:Float = 99
    
    let token = ArSmartApi.sharedApi.getToken()
    let hub = ArSmartApi.sharedApi.hub?.hid
    var scenes:Scenes = Scenes()
    var endpoint:Endpoint?
    var trigger:Trigger = Trigger()
    var play:Bool = false
    var index:Int = -1
    
    @IBOutlet weak var btn_prev: UIButton!
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var lbl_playlist: UILabel!
    @IBOutlet weak var slider_volume: UISlider!
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        
        trigger.endpoint = endpoint!

        
        
        scenes.load(token, hub: hub!) { (IsError, result) in
            if(!IsError){
                self.tableView.reloadData()
            }else{
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func style(){
        

        
        
        
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

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scenes.scenes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        
        
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = self.scenes.scenes[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.index = indexPath.row
        
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        
        return UITableViewCellEditingStyle(rawValue: 3)!
        
        
    }
    
    @IBAction func CreateTrigger(sender: AnyObject) {
        
        let scene = scenes.scenes[0]
        let payload = scene.payload
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        trigger.payload = payload
        trigger.save(token, hub: hub!) { (IsError, result) in
            if(!IsError){
            }else{
            }
        }
        
    }

}
