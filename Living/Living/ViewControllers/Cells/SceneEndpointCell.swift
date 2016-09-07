//
//  SceneEndpointCell.swift
//  Living
//
//  Created by Nelson FB on 23/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation

class SceneEndpointCell: UITableViewCell {
    

    public enum SceneEndpointCellMode {
        case Sonos, Level, Switch, Other
    }
    
    @IBOutlet weak var endpoint_image: UIImageView!
    @IBOutlet weak var endpoint_name: UILabel!
    @IBOutlet weak var endpoint_slider: UISlider!
    @IBOutlet weak var endpoint_switch: UISwitch!
    @IBOutlet weak var endpoint_switch_label: UILabel!
    @IBOutlet weak var endpoint_level_label: UILabel!
    
    
    var mode:SceneEndpointCellMode = SceneEndpointCellMode.Other
    var endpoint:Endpoint = Endpoint()
    
    
    var payload:Payload = Payload()
    
    var payload_switch:Payload = Payload()
    var payload_level:Payload = Payload()
    
    
    var delegate:SceneEndpointCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        endpoint_name.text = endpoint.name
        

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    
    func switchMode(){
    
        endpoint_slider.hidden = true
        endpoint_level_label.hidden = true
        endpoint_switch.hidden = false
        endpoint_switch_label.hidden = false
        
        
        
        if(payload_switch.value == 255){
            endpoint_switch.on = true
        }else{
            endpoint_switch.on = false
        }
        mode = SceneEndpointCellMode.Switch
        
    }
    func levelMode(){
        endpoint_slider.hidden = false
        endpoint_level_label.hidden = false
        endpoint_switch.hidden = true
        endpoint_switch_label.hidden = true
        endpoint_slider.continuous = false
        endpoint_slider.value = Float(Int(payload_level.value))
        mode = SceneEndpointCellMode.Level
        
    }
    
    func sonosMode(){
        endpoint_slider.hidden = false
        endpoint_level_label.hidden = false
        endpoint_switch.hidden = false
        endpoint_switch_label.hidden = false
        endpoint_slider.continuous = false
        endpoint_slider.value = Float(Int(payload_level.value))
        
        if(payload_switch.value == 255){
            endpoint_switch.on = true
        }else{
            endpoint_switch.on = false
        }
        
        mode = SceneEndpointCellMode.Sonos
        
    }
    
    func noneMode(){
        endpoint_slider.hidden = true
        endpoint_level_label.hidden = true
        endpoint_switch.hidden = true
        endpoint_switch_label.hidden = true
        mode = SceneEndpointCellMode.Other
    }
    @IBAction func SwitchChangeValue(sender: AnyObject) {
        
        endpoint_switch_label.text = (endpoint_switch.on) ? "Activado" : "Desactivado"
        payload_switch.value = (endpoint_switch.on) ? 255 : 0
        delegate?.ChangedPayload(self.payload_switch)
        
        if(endpoint.ui_class_command == "ui-sonos"){
            delegate?.ChangedPayload(self.payload_level)
        }
        
    }
    @IBAction func LevelChangeValue(sender: AnyObject) {
        
        
        payload_level.value = Int(endpoint_slider.value)
        endpoint_level_label.text = String(Int(endpoint_slider.value))
        endpoint_slider.value = Float(Int(endpoint_slider.value))
        delegate?.ChangedPayload(self.payload_level)
        
        if(endpoint.ui_class_command == "ui-sonos"){
            delegate?.ChangedPayload(self.payload_switch)
        }
        
        
    }
    
}

protocol SceneEndpointCellDelegate {
    func ChangedPayload(payload:Payload);
}
