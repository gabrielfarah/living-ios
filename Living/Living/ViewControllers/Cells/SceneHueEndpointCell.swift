//
//  SceneEndpointCell.swift
//  Living
//
//  Created by Nelson FB on 23/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import SwiftHUEColorPicker

class SceneHueEndpointCell: UITableViewCell {
    
    
    enum SceneHueEndpointCellMode {
        case sonos, level, `switch`, other
    }
    
    @IBOutlet weak var endpoint_image: UIImageView!
    @IBOutlet weak var endpoint_name: UILabel!
    @IBOutlet weak var endpoint_slider: UISlider!
    @IBOutlet weak var endpoint_switch: UISwitch!
    @IBOutlet weak var endpoint_switch_label: UILabel!
    @IBOutlet weak var endpoint_level_label: UILabel!
    
    
    var mode:SceneHueEndpointCellMode = SceneHueEndpointCellMode.other
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    func switchMode(){
        
        endpoint_slider.isHidden = true
        endpoint_level_label.isHidden = true
        endpoint_switch.isHidden = false
        endpoint_switch_label.isHidden = false
        
        
        
        if(payload_switch.value == 255){
            endpoint_switch.isOn = true
        }else{
            endpoint_switch.isOn = false
        }
        mode = SceneHueEndpointCellMode.switch
        
    }
    func levelMode(){
        endpoint_slider.isHidden = false
        endpoint_level_label.isHidden = false
        endpoint_switch.isHidden = true
        endpoint_switch_label.isHidden = true
        endpoint_slider.isContinuous = false
        endpoint_slider.value = Float(Int(payload_level.value))
        mode = SceneHueEndpointCellMode.level
        
    }
    
    func sonosMode(){
        endpoint_slider.isHidden = false
        endpoint_level_label.isHidden = false
        endpoint_switch.isHidden = false
        endpoint_switch_label.isHidden = false
        endpoint_slider.isContinuous = false
        endpoint_slider.value = Float(Int(payload_level.value))
        
        if(payload_switch.value == 255){
            endpoint_switch.isOn = true
        }else{
            endpoint_switch.isOn = false
        }
        
        mode = SceneHueEndpointCellMode.sonos
        
    }
    
    func noneMode(){
        endpoint_slider.isHidden = true
        endpoint_level_label.isHidden = true
        endpoint_switch.isHidden = true
        endpoint_switch_label.isHidden = true
        mode = SceneHueEndpointCellMode.other
    }
    @IBAction func SwitchChangeValue(_ sender: AnyObject) {
        
        endpoint_switch_label.text = (endpoint_switch.isOn) ? "Activado" : "Desactivado"
        payload_switch.value = (endpoint_switch.isOn) ? 255 : 0
        delegate?.ChangedPayload(self.payload_switch)
        
        if(endpoint.ui_class_command == "ui-sonos"){
            delegate?.ChangedPayload(self.payload_level)
        }
        
    }
    @IBAction func LevelChangeValue(_ sender: AnyObject) {
        
        
        payload_level.value = Int(endpoint_slider.value)
        endpoint_level_label.text = String(Int(endpoint_slider.value))
        endpoint_slider.value = Float(Int(endpoint_slider.value))
        delegate?.ChangedPayload(self.payload_level)
        
        if(endpoint.ui_class_command == "ui-sonos"){
            delegate?.ChangedPayload(self.payload_switch)
        }
        
        
    }
    
}

protocol SceneHueEndpointCellDelegate {
    func ChangedPayload(_ payload:Payload);
}
