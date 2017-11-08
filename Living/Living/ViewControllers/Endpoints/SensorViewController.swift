//
//  SonosViewController.swift
//  Living
//
//  Created by Nelson FB on 10/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SensorViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    
    let MIN_VALUE:Float = 0
    let MAX_VALUE:Float = 99
    
    let token = ArSmartApi.sharedApi.getToken()
    let hub = ArSmartApi.sharedApi.hub?.hid
    var scenes:Scenes = Scenes()
    var endpoint:Endpoint?
    var trigger:Trigger = Trigger()
    var play:Bool = false
    var index:Int = -1
    var time_seconds = 0;
    var time_seconds_until = 0;
    
    var selectedMode = 0
    var delegate:SensorViewControllerDelegate?
    

    @IBOutlet weak var switch_notification: UISwitch!
    @IBOutlet weak var btn_prev: UIButton!
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var lbl_playlist: UILabel!
    @IBOutlet weak var slider_volume: UISlider!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var date_picker: UIDatePicker!
    @IBOutlet weak var btn_save: UIButton!
    @IBOutlet weak var txt_time: UITextField!
    @IBOutlet weak var txt_time_until: UITextField!
    @IBOutlet weak var weeks_view: WeekDaysSegmentedControl!
    @IBOutlet weak var lbl_device_name: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var img_icon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        
        trigger.endpoint = endpoint!
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.layer.cornerRadius = 5.0
        self.txt_time.layer.cornerRadius = 5.0
        self.txt_time_until.layer.cornerRadius = 5.0
        
        scenes.load(token, hub: hub!) { (IsError, result) in
            if(!IsError){
                self.tableView.reloadData()
            }else{
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // inicializar información del endpoint
        
        lbl_device_name.text = endpoint?.name
        let image = UIImage(named:endpoint!.ImageNamed())!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)

        img_icon.image = image
        img_icon.tintColor = UIColor.white
        
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

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scenes.scenes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = self.scenes.scenes[(indexPath as NSIndexPath).row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        self.index = (indexPath as NSIndexPath).row
        
        
        selectedMode = self.scenes.scenes[(indexPath as NSIndexPath).row].sid
        
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAtIndexPath indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        
        return UITableViewCellEditingStyle(rawValue: 3)!
        
        
    }
    
    @IBAction func CreateTrigger(_ sender: AnyObject) {
        
        _ =  weeks_view.getDaysArray()

        
        let scene = scenes.scenes[0]
        let payload = scene.payload
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        trigger.modeId = selectedMode
        trigger.time = time_seconds
        trigger.time_until = time_seconds_until
        trigger.notify = switch_notification.isOn
        trigger.days = weeks_view.getDaysArray()
        trigger.payload = payload
        trigger.save(token, hub: hub!) { (IsError, result) in
            self.delegate?.SensorViewControllerDone(IsError, Result: result)
        }
        
    }
    @IBAction func TextEditingBegin(_ sender: UITextField) {
         date_picker.datePickerMode = UIDatePickerMode.time
        sender.inputView = date_picker
        date_picker.tag = sender.tag
         date_picker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        
        let calendar = Calendar.current
        let comp = (calendar as NSCalendar).components([.hour, .minute], from: sender.date)
        
        let hour = comp.hour
        let minute = comp.minute

        
        let final_minute = hour! * 60 + minute!
        print("seconds:",final_minute)

        if(sender.tag == 0){
            time_seconds = final_minute
            txt_time.text = dateFormatter.string(from: sender.date)
        }else{
            time_seconds_until = final_minute
            txt_time_until.text = dateFormatter.string(from: sender.date)
        }
        
        
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Escenas"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No hay escenas registradas"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
  

}
protocol SensorViewControllerDelegate {
    // protocol definition goes here
    func SensorViewControllerDone(_ IsError:Bool, Result:String)

    
    
}
