//
//  SceneEndpointCell.swift
//  Living
//
//  Created by Nelson FB on 23/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import SwiftHUEColorPicker
import SwiftHUEColorPicker

class SceneHueEndpointCell: UITableViewCell, SwiftHUEColorPickerDelegate {
    
    
    enum SceneHueEndpointCellMode {
        case sonos, level, `switch`,hue, other
    }
    
    @IBOutlet weak var endpoint_image: UIImageView!
    @IBOutlet weak var endpoint_name: UILabel!
    @IBOutlet weak var endpoint_slider: UISlider!
    @IBOutlet weak var endpoint_switch: UISwitch!
    @IBOutlet weak var endpoint_switch_label: UILabel!
    @IBOutlet weak var endpoint_level_label: UILabel!
    @IBOutlet weak var colorPicker2: SwiftHUEColorPicker!
    
    var mode:SceneHueEndpointCellMode = SceneHueEndpointCellMode.hue
    var endpoint:Endpoint = Endpoint()
    var payload:Payload = Payload()
    var payload_switch:Payload = Payload()
    var payload_level:Payload = Payload()
    var delegate:SceneEndpointCellDelegate?
    var color:UIColor?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        endpoint_name.text = endpoint.name
        
        colorPicker2.delegate = self
        colorPicker2.direction = SwiftHUEColorPicker.PickerDirection.horizontal
        colorPicker2.type = SwiftHUEColorPicker.PickerType.color
        
        
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
    func getPayload(_ id:Int,scene:Scene)->Payload?{
        let index = scene.payload.index(where: {$0.endpoint_id == id})
        if (index != nil){
            
            
            return scene.payload[index!]
            
        }else{
            return nil
        }
    }
    func applyPayload(tableView:UITableView,indexPath:IndexPath,scene:Scene){
        

        
        
        
        if let real_payload = getPayload(endpoint.id,scene:scene){
            
            
            let payload = Payload(type:real_payload.type,node:real_payload.node,value:real_payload.value,target:real_payload.target,endpoint_id:real_payload.endpoint_id,ip:real_payload.ip,function_name:real_payload.function_name,parameters:[String]())
            self.payload = payload
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)

            
        }else{
            let payload_level = Payload(type:endpoint.getEndpointTypeString(),node:endpoint.node,value:0,target:"hue",endpoint_id:endpoint.id,ip:endpoint.ip_address,function_name:"turn_on_all_lights",parameters:[])
            
            
            
            self.payload = payload_level
            
        }
        

                

    }
    
    func valuePicked(_ color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        //self.view.backgroundColor = color
        //img_hue_light.tintColor = color
        self.color = color
        

        
        switch type {
        case SwiftHUEColorPicker.PickerType.color:
            
            break
            
        case SwiftHUEColorPicker.PickerType.saturation:
            
            break
        default:
            break
            
        }
    }
    
    func valuePickedEnd() {

        print("after")
        //TODO: Aqui se ejecuta el cambio de color.
        //let token = ArSmartApi.sharedApi.getToken()
        //let hub = ArSmartApi.sharedApi.hub?.hid
        
       
        _ = self.color!.cgColor.numberOfComponents;
        
        let components = self.color!.cgColor.components;
        
        let r:Int = Int(components![0] * 255)
        let g:Int = Int(components![1] * 255)
        let b:Int = Int(components![2] * 255)
        self.payload.rgb = (Double(r),Double(g),Double(b))

        delegate?.ChangedPayload(self.payload)
        
        
    }
    
    
}

protocol SceneHueEndpointCellDelegate {
    func ChangedPayload(_ payload:Payload);
}
