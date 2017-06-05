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
        case sonos, level, `switch`, other
    }
    
    @IBOutlet weak var endpoint_image: UIImageView!
    @IBOutlet weak var endpoint_name: UILabel!
    @IBOutlet weak var endpoint_slider: UISlider!
    @IBOutlet weak var endpoint_switch: UISwitch!
    @IBOutlet weak var endpoint_switch_label: UILabel!
    @IBOutlet weak var endpoint_level_label: UILabel!
    
    
    var mode:SceneEndpointCellMode = SceneEndpointCellMode.other
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
        
        endpoint_switch_label.text = (endpoint_switch.isOn) ? "Activado" : "Desactivado"

        
        mode = SceneEndpointCellMode.switch
        
    }
    func levelMode(){
        endpoint_slider.isHidden = false
        endpoint_level_label.isHidden = false
        endpoint_switch.isHidden = true
        endpoint_switch_label.isHidden = true
        endpoint_slider.isContinuous = false
        endpoint_slider.value = Float(Int(payload_level.value))
        mode = SceneEndpointCellMode.level
        
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
        
        mode = SceneEndpointCellMode.sonos
        
    }
    
    func noneMode(){
        endpoint_slider.isHidden = true
        endpoint_level_label.isHidden = true
        endpoint_switch.isHidden = true
        endpoint_switch_label.isHidden = true
        mode = SceneEndpointCellMode.other
    }
    
    func applyPayload(tableView:UITableView,indexPath:IndexPath,scene:Scene){
    

        if(endpoint.ui_class_command == "ui-sonos"){
            
            // Se necesita verificar si existe dos payloads
            
            
            let target = (endpoint.ui_class_command == "ui-sonos") ? "sonos" : ""
            if let payload_level = getSonosPayload(endpoint.id,function_name: "set_volume",scene:scene){
                
                if(payload_level.endpoint_id != 0 ){
                    
                    let payload = Payload(type:payload_level.type,node:payload_level.node,value:payload_level.value,target:target,endpoint_id:payload_level.endpoint_id,ip:payload_level.ip,function_name:"set_volume",parameters:payload_level.parameters)
                    self.payload_level = payload
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
                    
                }else{
                    let payload_level = Payload(type:endpoint.getEndpointTypeString(),node:endpoint.node,value:0,target:target,endpoint_id:endpoint.id,ip:endpoint.ip_address,function_name:"set_volume",parameters:[])
                    
                    
                    
                    self.payload_level = payload_level
                    
                }
                
            }else{
                let payload_level = Payload(type:endpoint.getEndpointTypeString(),node:endpoint.node,value:0,target:target,endpoint_id:endpoint.id,ip:endpoint.ip_address,function_name:"set_volume",parameters:[])
                
                
                self.payload_level = payload_level
                
            }
            
            
            if let payload_switch = getSonosPayload(endpoint.id,function_name: "play",scene:scene){
                if(payload_switch.endpoint_id != 0){
                    
                    let payload = Payload(type:payload_switch.type,node:payload_switch.node,value:payload_switch.value,target:target,endpoint_id:payload_switch.endpoint_id,ip:payload_switch.ip,function_name:"play",parameters:payload_switch.parameters)
                    self.payload_switch = payload
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
                    
                }else{
                    
                    
                    let payload_switch = Payload(type:endpoint.getEndpointTypeString(),node:endpoint.node,value:0,target:target,endpoint_id:endpoint.id,ip:endpoint.ip_address,function_name:"play",parameters:[])
                    
                    
                    self.payload_switch = payload_switch
                }
            }else{
                let payload_switch = Payload(type:endpoint.getEndpointTypeString(),node:endpoint.node,value:0,target:target,endpoint_id:endpoint.id,ip:endpoint.ip_address,function_name:"play",parameters:[])
                self.payload_switch = payload_switch
                
            }
            
            
        }else{
            if let real_payload = getPayload(endpoint.id,scene:scene){
                
                if(real_payload.endpoint_id != 0){
                    let payload = Payload(type:real_payload.type,node:real_payload.node,value:real_payload.value,target:real_payload.target,endpoint_id:real_payload.endpoint_id,ip:real_payload.ip,function_name:real_payload.function_name,parameters:real_payload.parameters)
                    
                    
                    if(endpoint.isSwitch()){
                        self.payload_switch = payload
                    }else if(endpoint.isLevel()){
                        self.payload_level = payload
                    }else{
                        self.payload = payload
                        self.payload_level = payload
                        self.payload_switch = payload
                    }
                    
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
                    
                }else{
                    
                    let payload = Payload(type:endpoint.getEndpointTypeString(),node:endpoint.node,value:0,target:"",endpoint_id:endpoint.id,ip:endpoint.ip_address,function_name:endpoint.GetFunctionValue(),parameters:[])
                    if(endpoint.isSwitch()){
                        self.payload_switch = payload
                    }else if(endpoint.isLevel()){
                        self.payload_level = payload
                    }else{
                        self.payload = payload
                        self.payload_level = payload
                        self.payload_switch = payload
                    }
                    
                }
            }else{
                let payload = Payload(type:endpoint.getEndpointTypeString(),node:endpoint.node,value:0,target:"",endpoint_id:endpoint.id,ip:endpoint.ip_address,function_name:endpoint.GetFunctionValue(),parameters:[])
                if(endpoint.isSwitch()){
                    self.payload_switch = payload
                }else if(endpoint.isLevel()){
                    self.payload_level = payload
                }else{
                    self.payload = payload
                    self.payload_level = payload
                    self.payload_switch = payload
                }
            }
            
            
            
            
        }
        
        
        
        if (endpoint.isLevel()){
            self.levelMode()
        }else if(endpoint.isSwitch()){
            self.switchMode()
        }else if(endpoint.isSonos()){
            self.sonosMode()
        }else{
            
            self.switchMode()
            //self.noneMode()
        }

    
    }
    func getSonosPayload(_ id:Int,function_name:String,scene:Scene)->Payload?{
        if let index = scene.payload.index(where: {($0.endpoint_id == id) && ($0.function_name == function_name)}){
            return scene.payload[index]
        }else{
            return nil
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

protocol SceneEndpointCellDelegate {
    func ChangedPayload(_ payload:Payload);
}
