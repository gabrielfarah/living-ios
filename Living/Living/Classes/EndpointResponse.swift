//
//  EndpointResponse.swift
//  Living
//
//  Created by Nelson FB on 2/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import SwiftyJSON

class EndpointResponse{

    var uid:String
    var manufacturer_name:String
    var category:CategoryEndpoint
    var endpoint_classes = [String]()
    var port:String
    var name:String
    var endpoint_type:String
    var ip_address:String
    var ui_class_command:String
    
    
    init(){
    
        self.uid = ""
        self.manufacturer_name = ""
        self.category = CategoryEndpoint()
        self.port = ""
        self.endpoint_type = ""
        self.ip_address = ""
        self.ui_class_command = ""
        self.name = ""
    }
    init(uid:String,manufacturer_name:String, category:CategoryEndpoint, endpoint_classes:[String], port:String, endpoint_type:String, ip_address:String, ui_class_command:String,name:String){
        
        self.uid = uid
        self.manufacturer_name = manufacturer_name
        self.category = category
        self.port = port
        self.endpoint_type = endpoint_type
        self.ip_address = ip_address
        self.ui_class_command = ui_class_command
        self.name = name
    }
    

    
    func CreateEndpoint()->Endpoint{
    
        let e_name = self.name
        
        
        let active = 0
        

        let category = self.category
        
        
        
        let created_at  = Date()
        let endpoint_type = Endpoint.ConvertType(self.endpoint_type)
        let favorite = 0
        let id = 0
        let image = ""
        let ip_address = self.ip_address
        let lib_type = ""
        let manufacturer_name = self.manufacturer_name
        let name = self.name
        let node = 0
        let pid = ""
        let port = self.port
        let proto_ver = ""
        //TODO: inicializar
        let room:Room = Room()
        let sensor = 0
        let sleep_cap = false
        let state = 0
        let ui_class_command = self.ui_class_command
        let uid = self.uid
        let updated_at = Date()
        let version = ""
        let wkup_intv = ""
        
        let endpoint = Endpoint(active: active, category: category, created_at: created_at, endpoint_type: endpoint_type, favorite: favorite, id: id, image: image, ip_address: ip_address, lib_type: lib_type, manufacturer_name: manufacturer_name, name: name, node: node, pid: pid, port: port, proto_ver: proto_ver, room: room, sensor: sensor, sleep_cap: sleep_cap, state: state, ui_class_command: ui_class_command, uid: uid, updated_at: updated_at, version: version, wkup_intv: wkup_intv)
        
        return endpoint
        
    
    }
    
    
    /*
    
    
    {
    "uid" : "RINCON_B8E937B4025E01400",
    "manufacturer_name" : "Sonos",
    "category" : {
    "code" : 1,
    "description" : "Entertaiment"
    },
    "endpoint_classes" : [
    "SONOS-5.3"
    ],
    "port" : "1400",
    "endpoint_type" : "wifi",
    "name" : "Living Room",
    "ip_address" : "192.168.1.102",
    "ui_class_command" : "ui-sonos"
    }*/

}
