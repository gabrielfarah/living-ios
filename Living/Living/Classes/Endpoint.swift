//
//  Endpoint.swift
//  Living
//
//  Created by Nelson FB on 26/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Endpoint{

    enum EndPointType {
        case Wifi, Zwave
    }

    var active:Int
    var category:CategoryEndpoint
    var created_at:NSDate
    var endpoint_type:EndPointType
    var favorite:Int
    var id:Int
    var image:String
    var ip_address:String
    var lib_type:String
    var manufacturer_name:String
    var name:String
    var node:Int
    var pid:String
    var port:String
    var proto_ver:String
    var room:Room
    var sensor:Int
    var sleep_cap:Bool
    var state:Int
    var ui_class_command:String
    var uid:String
    var updated_at:NSDate
    var version:String
    var wkup_intv:String
    var is_room_available:Bool
        
    
    init(){
        self.active = 0
        self.category = CategoryEndpoint()
        self.created_at = NSDate()
        self.endpoint_type = EndPointType.Wifi
        self.favorite = 0
        self.id = 0
        self.image = ""
        self.ip_address = ""
        self.lib_type = ""
        self.manufacturer_name = ""
        self.name = ""
        self.node = 0
        self.pid = "0"
        self.port = ""
        self.proto_ver = "0"
        self.room = Room()
        self.sensor = 0
        self.sleep_cap = false
        self.state = 0
        self.ui_class_command = ""
        self.uid = ""
        self.updated_at = NSDate()
        self.version = ""
        self.wkup_intv = "0"
        self.is_room_available = false
    }
    
    init(active:Int, category:CategoryEndpoint, created_at:NSDate, endpoint_type:EndPointType, favorite:Int, id:Int, image:String, ip_address:String?=nil, lib_type:String?=nil, manufacturer_name:String, name:String, node:Int?=nil, pid:String?=nil, port:String?=nil, proto_ver:String?=nil, room:Room, sensor:Int, sleep_cap:Bool, state:Int?=nil, ui_class_command:String, uid:String, updated_at:NSDate, version:String?=nil, wkup_intv:String?=nil){
    
        self.active = active
        self.category = category
        self.created_at = created_at
        self.endpoint_type = endpoint_type
        self.favorite = favorite
        self.id = id
        self.image = image
        self.ip_address = ip_address ?? ""
        self.lib_type = lib_type ?? ""
        self.manufacturer_name = manufacturer_name
        self.name = name
        self.node = node ?? 0
        self.pid = pid ?? "0"
        self.port = port ?? ""
        self.proto_ver = proto_ver ?? "0"
        self.room = room
        self.sensor = sensor
        self.sleep_cap = sleep_cap
        self.state = state ?? 0
        self.ui_class_command = ui_class_command
        self.uid = uid
        self.updated_at = updated_at
        self.version = version ?? ""
        self.wkup_intv = wkup_intv ?? "0"
        self.is_room_available = true
    
    }
    
    
    init(name:String,endpoint_type:EndPointType, favorite:Int, id:Int, image:String, ui_class_command:String){
        
        self.active = 0
        self.category = CategoryEndpoint()
        self.created_at = NSDate()
        self.endpoint_type = endpoint_type
        self.favorite = favorite
        self.id = 0
        self.image = image
        self.ip_address = ""
        self.lib_type = ""
        self.manufacturer_name = ""
        self.name = name
        self.node = 0
        self.pid = ""
        self.port = "0"
        self.proto_ver = "0"
        self.room = Room()
        self.sensor = 0
        self.sleep_cap = false
        self.state = 0
        self.ui_class_command = ui_class_command
        self.uid = ""
        self.updated_at = NSDate()
        self.version = ""
        self.wkup_intv = "0"
        self.is_room_available = false
    }
    
    
    func Create(hub:Int,token:String,completion: (IsError:Bool,result: String) -> Void){
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Endpoints), hub)
        

        
        let json_parameters  = JSON([
        
                "category": ["id":1,"description":"Entertaiment"],
                "room": self.room.description,
                "hub": hub,
                "name": self.name,
                "manufacturer_name": self.manufacturer_name,
                "favorite": self.favorite,
                "image": self.image,
                "uid": self.uid,
                "active": self.active,
                "state": self.state,
                "endpoint_type": self.getEndpointTypeString(),
                "ui_class_command": self.ui_class_command,
                "ip_address": self.ip_address,
                "port": self.port,
                "sleep_cap": false,


        ])
        //convert the JSON to a raw String
        if let string = json_parameters.rawString() {
            //Do something you want
            print(string)
        }
        

        
        Alamofire.request(.POST,endpoint,headers: headers, parameters:[:], encoding:.Custom({convertible, params in
            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = json_parameters.rawString()!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            mutableRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            return (mutableRequest, nil)
        }))
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .Success:
                    
                    // TODO: se debe consultar la url que responde esste tema.
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    
                    

                    completion(IsError: false,result: "")
                    
                    
                case .Failure:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(IsError:true,result: response_string!)
                    
                    
                    
                }
                
                
        }

    
    
    }
    
    func CheckCreatedResponse(token:String,url:String,completion: (IsError:Bool,result: String) -> Void){
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        Alamofire.request(.GET,ArSmartApi.sharedApi.ApiUrl(url),encoding: .JSON,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .Success:
                    
                    // TODO: se debe consultar la url que responde esste tema.
                    //let data = NSData(data: response.data!)
                    //var json = JSON(data: data)

                    
                    
                    completion(IsError: false,result: "")
                    
                    
                case .Failure:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(IsError:true,result: response_string!)
                    
                    
                    
                }
                
                
        }
        
    }
    
    
    func Update(hub:Int,token:String,completion: (IsError:Bool,result: String) -> Void){
        
        
    }
    
    func command_level_on(hub:Int,token:String, completion: (IsError:Bool,result: String) -> Void){
    
        if(self.ui_class_command == "ui-switch-binary-zwave"){
        
            let headers = [
                "Authorization": "JWT "+token,
                "Accept": "application/json"
            ]
            
            let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub)
            
            
            let json_parameters: [String: AnyObject]  = [
                "type":"zwave",
                "function":"zwif_level_set",
                "v":"99",
                "node":self.node,
                "parameters":[]
                
            ]
            
            let array = JSON([json_parameters])
            
            
            
            
            Alamofire.request(.POST,endpoint,headers: headers, parameters:[:], encoding:.Custom({convertible, params in
                let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
                mutableRequest.HTTPBody = array.rawString()!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                mutableRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                return (mutableRequest, nil)
            }))
                .validate()
                .responseJSON { response  in
                    switch response.result {
                        
                    case .Success:
                        
                        
                        completion(IsError: false,result: "")
                        
                        
                    case .Failure:
                        let data = NSData(data: response.data!)
                        var json = JSON(data: data)
                        let response_string = (json["ERROR"]).rawString()
                        completion(IsError:true,result: response_string!)
                        
                        
                        
                    }
                    
                    
            }
        
        }
    
    
    }
    
    func GetLevel(hub:Int,token:String,value:String,function:String, completion: (IsError:Bool,result: String) -> Void){
        
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsGet), hub)
        
        
        let json_parameters: [String: AnyObject]  = [
            "type":self.getEndpointTypeString(),
            "function":function,
            "v":value,
            "node":self.node,
            "parameters":[]
            
        ]
        
        let array = JSON([json_parameters])
        
        
        
        
        Alamofire.request(.POST,endpoint,headers: headers, parameters:[:], encoding:.Custom({convertible, params in
            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = array.rawString()!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            mutableRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            return (mutableRequest, nil)
        }))
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .Success:
                    
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let url = (json["url"]).rawString()
                    completion(IsError: false,result: url!)
                    
                    
                case .Failure:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(IsError:true,result: response_string!)
                    
                    
                    
                }
                
                
        }
        
        
        
        
    }
    
    func SetLevel(hub:Int,token:String,value:String,function:String, completion: (IsError:Bool,result: String) -> Void){
        
        
        
            let headers = [
                "Authorization": "JWT "+token,
                "Accept": "application/json"
            ]
            
            let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub)
            
            
            let json_parameters: [String: AnyObject]  = [
                "type":self.getEndpointTypeString(),
                "function":function,
                "v":value,
                "node":self.node,
                "parameters":[]
                
            ]
            
            let array = JSON([json_parameters])
            
            
            
            
            Alamofire.request(.POST,endpoint,headers: headers, parameters:[:], encoding:.Custom({convertible, params in
                let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
                mutableRequest.HTTPBody = array.rawString()!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                mutableRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                return (mutableRequest, nil)
            }))
                .validate()
                .responseJSON { response  in
                    switch response.result {
                        
                    case .Success:
                        
                        
                        completion(IsError: false,result: "")
                        
                        
                    case .Failure:
                        let data = NSData(data: response.data!)
                        var json = JSON(data: data)
                        let response_string = (json["ERROR"]).rawString()
                        completion(IsError:true,result: response_string!)
                        
                        
                        
                    }
                    
                    
            }
            
        
        
        
    }
    func SetLevel(hub:Int,token:String,value:String,function:String,parameters:String, completion: (IsError:Bool,result: String) -> Void){
        
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub)
        
        
        let json_parameters: [String: AnyObject]  = [
            "type":self.getEndpointTypeString(),
            "function":function,
            "v":value,
            "node":self.node,
            "parameters":parameters
            
        ]
        
        let array = JSON([json_parameters])
        
        
        
        
        Alamofire.request(.POST,endpoint,headers: headers, parameters:[:], encoding:.Custom({convertible, params in
            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = array.rawString()!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            mutableRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            return (mutableRequest, nil)
        }))
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .Success:
                    
                    
                    completion(IsError: false,result: "")
                    
                    
                case .Failure:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(IsError:true,result: response_string!)
                    
                    
                    
                }
                
                
        }
        
        
        
        
    }
    
    

    func setValue(hub:Int,token:String,value:String, completion: (IsError:Bool,result: String) -> Void){
    

        let parameters = []
    
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub)
        
        
        let json_parameters: [String: AnyObject]  = [
            "type":self.getEndpointTypeString(),
            "function":Endpoint.GetFunctionValue(self.ui_class_command),
            "v":value,
            "node":self.node,
            "parameters":parameters
            
        ]
        
        let array = JSON([json_parameters])
        
        
        
        Alamofire.request(.POST,endpoint,headers: headers, parameters:[:], encoding:.Custom({convertible, params in
            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = array.rawString()!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            mutableRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            return (mutableRequest, nil)
        }))
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .Success:
                    
                    
                    completion(IsError: false,result: "")
                    
                    
                case .Failure:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(IsError:true,result: response_string!)
                    
                    
                    
                }
                
                
        }
    
    
    
    
    }
    
    func isSensor()->Bool{
    

 
        switch (self.ui_class_command) {
        
            case "ui-temp-sensor-zwave":
                return true
            case "ui-sensor-open-close-zwave":
                return true
            case "ui-sensor-motion-zwave":
                return true
            case "ui-sensor-binary-zwave":
                return true
            case "ui-sensor-multilevel-zwave":
                return true
            case "ui-water-sensor-zwave":
                return true
            case "ui-energy-sensor-zwave":
                return true
            default:
                return false
            
        
        }
    
    
    }
    
    func ImageNamed()->String{
    
        switch (self.image) {
        case "light":
            return "light_icon"
        case "light2":
            return "light_2_icon"
        case "light3":
            return "light_3_icon"
        case "light4":
            return "light_4_icon"
        case "light5":
            return "light_5_icon"
        case "hue":
            return "hue_icon1"
        case "hue2":
            return "hue_icon2"
        case "sonos":
            return "music_icon"
        case "music":
            return "music_2_icon"
        case "music2":
            return "music_3_icon"
        case "music3":
            return "music_4_icon"
        case "music4":
            return "music_5_icon"
        case "power-outlet":
            return "power_outlet_icon"
        case "power-outlet2":
            return "power_outlet_2_icon"
        case "power-outlet3":
            return "switch_icon"
        case "power-outlet4":
            return "tv_icon"
        case "door-lock":
            return "door_lock_icon"
        case "door-lock2":
            return "door_lock_2_icon"
        case "shades":
            return "shades_2_icon"
        case "shades2":
            return "shades_2_icon"
        case "shades3":
            return "shades_3_icon"
        case "shades4":
            return "shades_4_icon"
        case "temperature":
            return "ac_icon"
        case "temperature2":
            return "temperature_icon"
        case "sensor":
            return "sensor_icon"
        case "alarm":
            return "alarm_icon"
        case "alarm2":
            return "alarm_2_icon"
        case "alarm3":
            return "alarm_3_icon"
        case "battery":
            return "battery_icon"
        case "coffee-maker":
            return "cofee_maker_icon"
        case "door":
            return "door_icon"
        case "door2":
            return "door_2_icon"
        case "energy":
            return "energy_icon"
        case "energy2":
            return "energy_2_icon"
        case "energy3":
            return "energy_sensor_icon"
        case "energy4":
            return "power_icon"
        case "lamp":
            return "lamp_icon"
        case "lamp2":
            return "lamp_2_icon"
        case "lamp3":
            return "lamp_3_icon"
        case "movement-sensor":
            return "movement_sensor_icon"
        case "movement-sensor2":
            return "movement_sensor_2_icon"
        case "movement-sensor3":
            return "movement_sensor_3_icon"
        case "movement-sensor4":
            return "movement_sensor_4_icon"
        case "open-close-sensor":
            return "open_close_sensor_icon"
        case "open-close-sensor2":
            return "open_close_sensor_2_icon"
        case "open-close-sensor3":
            return "open_close_sensor_3_icon"
        case "water":
            return "water_icon"
        case "water2":
            return "water_2_icon"
        case "water3":
            return "water_3_icon"
        default:
            return "default_icon"
            
        }
    }
    

    
    static func GetFunctionValue(ui_class_command:String)->String{
        switch(ui_class_command){
            case "ui-binary-outlet-zwave":
                return "zwif_switch_set" // bien
            case "ui-binary-light-zwave":
                return "zwif_switch_set" // bien
            case "ui-level-light-zwave":
                return "zwif_level_set" // Bien
            case "ui-sensor-open-close-zwave":
                return "zwif_switch_get" // Esta activo o inactivo, este no se pide no ha necesidad
            case "ui-lock-zwave":
                return "zwif_dlck_op_set" //TODO: Preguntar si este es correcto
            case "ui-hue":
                return "zwif_level_set" //TODO: Es
            case "ui-sensor-motion-zwave":
                return "zwif_level_set" //TODO:Este es un GET (todo lo que sea sensor, con el getall)
            case "ui-level-thermostat-zwave":
                return "zwif_level_set" //TODO: Es
            case "ui-shades-zwave":
                return "zwif_level_set" //TODO: Es
                
            case "ui-water-sensor-zwave":
                return "zwif_level_set" // Sensor

            return "zwif_level_set" //TODO:Este es un GET (todo lo que sea sensor, con el getall)
            default:
                return "zwif_basic_set" //TODOS los dispositivos es binario (0,255)
                
                
        }
    }
    
    
    static func ConvertType(type:String)->EndPointType{
    
        if(type == "wifi"){
            return EndPointType.Wifi
        
        }else{
            return EndPointType.Zwave
        }
    
    }
    func getEndpointTypeString()->String{
        if(self.endpoint_type == EndPointType.Wifi){
            return "wifi"
        }else{
            return "zwave"
        }
    
    }
    
    
    
    
    
    //TODO: Sonos
    func playSonos(hub:Int,token:String,parameters:[String:AnyObject], completion: (IsError:Bool,result: String) -> Void){
        setValueSonos(hub, token: token, function: "play", parameters: parameters) { (IsError, result) in
            completion(IsError: IsError,result:result)
        }
    }
    func pauseSonos(hub:Int,token:String,parameters:[String:AnyObject], completion: (IsError:Bool,result: String) -> Void){
        setValueSonos(hub, token: token, function: "pause", parameters: parameters) { (IsError, result) in
            completion(IsError: IsError,result:result)
        }
    }
    func nextSonos(hub:Int,token:String,parameters:[String:AnyObject], completion: (IsError:Bool,result: String) -> Void){
        setValueSonos(hub, token: token, function: "next", parameters: parameters) { (IsError, result) in
            completion(IsError: IsError,result:result)
        }
    }
    func prevSonos(hub:Int,token:String,parameters:[String:AnyObject], completion: (IsError:Bool,result: String) -> Void){
        setValueSonos(hub, token: token, function: "prev", parameters: parameters) { (IsError, result) in
            completion(IsError: IsError,result:result)
        }
    }
    func setVomuneSonos(hub:Int,token:String,parameters:[String:AnyObject], completion: (IsError:Bool,result: String) -> Void){
        setValueSonos(hub, token: token, function: "set_volume", parameters: parameters) { (IsError, result) in
            completion(IsError: IsError,result:result)
        }
    }
    
    func setValueSonos(hub:Int,token:String,function:String,parameters:[String:AnyObject], completion: (IsError:Bool,result: String) -> Void){
        

        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub)
        
        
        let json_parameters: [String: AnyObject]  = [
            "type":self.getEndpointTypeString(),
            "target":"sonos",
            "ip":ip_address,
            "function":Endpoint.GetFunctionValue(self.ui_class_command),
            "parameters":parameters
            
        ]
        
        let array = JSON([json_parameters])
        
        
        
        Alamofire.request(.POST,endpoint,headers: headers, parameters:[:], encoding:.Custom({convertible, params in
            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = array.rawString()!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            mutableRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            return (mutableRequest, nil)
        }))
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .Success:
                    
                    
                    completion(IsError: false,result: "")
                    
                    
                case .Failure:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(IsError:true,result: response_string!)
                    
                    
                    
                }
                
                
        }
        
        
        
        
    }
    
    
        
        
        
        
        
        
    
    

    //Comandos para el Hue
    //Apagar
    //Prender
    //Principal
    //get_ui_info: Retorna toda la información, de aqui se obtiene un json con las opciones de luz
    //Todo lo que es sensor, actualizar el estado y ya!!!
    

}