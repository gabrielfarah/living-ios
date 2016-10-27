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
        case wifi, zwave
    }

    var active:Int
    var category:CategoryEndpoint
    var created_at:Date
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
    var updated_at:Date
    var version:String
    var wkup_intv:String
    var is_room_available:Bool
    
    
    struct JSONStringArrayEncoding: ParameterEncoding {
        private let array: [[String: AnyObject]]
        
        init(array: [[String: AnyObject]]) {
            self.array = array
        }
        
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            var urlRequest1 = urlRequest.urlRequest
            
            let data = try JSONSerialization.data(withJSONObject: array, options: [])
            
            if urlRequest1?.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest1?.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                
            }
            
            urlRequest1?.httpBody = data
            
            return urlRequest1!
        }
    }
    
    
        
    
    init(){
        self.active = 0
        self.category = CategoryEndpoint()
        self.created_at = Date()
        self.endpoint_type = EndPointType.wifi
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
        self.updated_at = Date()
        self.version = ""
        self.wkup_intv = "0"
        self.is_room_available = false
    }
    
    init(active:Int, category:CategoryEndpoint, created_at:Date, endpoint_type:EndPointType, favorite:Int, id:Int, image:String, ip_address:String?=nil, lib_type:String?=nil, manufacturer_name:String, name:String, node:Int?=nil, pid:String?=nil, port:String?=nil, proto_ver:String?=nil, room:Room, sensor:Int, sleep_cap:Bool, state:Int?=nil, ui_class_command:String, uid:String, updated_at:Date, version:String?=nil, wkup_intv:String?=nil){
    
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
        self.created_at = Date()
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
        self.updated_at = Date()
        self.version = ""
        self.wkup_intv = "0"
        self.is_room_available = false
    }
    
    
    func Create(_ hub:Int,token:String,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Endpoints), hub)
        

        
        var json_parameters  = [
        
                "category": ["code":self.category.code,"description":self.category.description],
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

                //"ip_address": self.ip_address,
                "port": self.port,
                "sleep_cap": false,


        ] as [String : Any]
        
        if self.ip_address != ""{
            json_parameters["ip_address"] = self.ip_address
        }
        
        if self.node != 0 {
            json_parameters["node"] = self.node
        }

        
        Alamofire.request(endpoint, method: .post, parameters:json_parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    // TODO: se debe consultar la url que responde esste tema.
                    let data = NSData(data: response.data!) as Data
                    _ = JSON(data: data)
                    completion(false, "")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                    
                }
                
                
        }

    
    
    }
    
    func CheckCreatedResponse(_ token:String,url:String,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        Alamofire.request(ArSmartApi.sharedApi.ApiUrl(url),method:.post, encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    // TODO: se debe consultar la url que responde esste tema.
                    //let data = NSData(data: response.data!)
                    //var json = JSON(data: data)

                    
                    
                    completion(false,"")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                    
                }
                
                
        }
        
    }
    
    
    func Update(_ hub:Int,token:String,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Endpoints), hub)
        
        
        
        var json_parameters  = [
            
            "category": ["code":self.category.code,"description":self.category.description],
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
            
            //"ip_address": self.ip_address,
            "port": self.port,
            "sleep_cap": false,
            
            
            ] as [String : Any]
        
        if self.ip_address != ""{
            json_parameters["ip_address"] = self.ip_address
        }
        
        if self.node != 0 {
            json_parameters["node"] = self.node
        }
        
        
        Alamofire.request(endpoint, method: .put, parameters:json_parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    // TODO: se debe consultar la url que responde esste tema.
                    let data = NSData(data: response.data!) as Data
                    _ = JSON(data: data)
                    completion(false, "")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                    
                }
                
                
        }

        
    }
    
    func Delete(_ hub:Int,token:String,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        //Z-Wave devices cannot be directly deleted. Send the zwnet_remove command to hub first."
        
        if(self.endpoint_type == EndPointType.wifi){
            DeleteWIFI(hub, token: token, completion: { (IsError, result) in
                completion(IsError,result)
            })
        }else{
            RequestRemoveZWaveToken(token, hub: hub, completion: { (IsError, result) in
                completion(IsError,result)
            })
        }
    }
    
    func DeleteZWave(_ hub:Int,token:String,completion: (_ IsError:Bool,_ result: String) -> Void){
    
    //Z-Wave devices cannot be directly deleted. Send the zwnet_remove command to hub first."
    }
    
    
    func DeleteWIFI(_ hub:Int,token:String,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Endpoint), hub,self.id)
        
        
        

        
        
        Alamofire.request(endpoint,method:.delete ,encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    // TODO: se debe consultar la url que responde esste tema.
                    let data = NSData(data: response.data!) as Data
                    _ = JSON(data: data)
                    
                    
                    
                    completion( false,"")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["detail"]).rawString()
                    completion(true, response_string!)
                    
                    
                    
                }
                
                
        }
    }
    
    func command_level_on(_ hub:Int,token:String, completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
    
        if(self.ui_class_command == "ui-switch-binary-zwave"){
        
            let headers = [
                "Authorization": "JWT "+token,
                "Accept": "application/json"
            ]
            
            let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub)
            
            
            let json_parameters: [String: AnyObject]  = [
                "type":"zwave" as AnyObject,
                "function":"zwif_level_set" as AnyObject,
                "v":"99" as AnyObject,
                "node":self.node as AnyObject,
                "parameters":[AnyObject?]() as AnyObject
                
            ]
            
   
            
            let encoding = JSONStringArrayEncoding(array: [json_parameters])
            
            
            Alamofire.request(endpoint,method:.post, parameters:[:], encoding:encoding,headers: headers)
                .validate()
                .responseJSON { response  in
                    switch response.result {
                        
                    case .success:
                        
                        
                        completion( false,"")
                        
                        
                    case .failure:
                        let data = NSData(data: response.data!) as Data
                        var json = JSON(data: data)
                        let response_string = (json["ERROR"]).rawString()
                        completion(true,response_string!)
                        
                        
                        
                    }
                    
                    
            }
        
        }
    
    
    }
    
    func GetLevel(_ hub:Int,token:String,value:String,function:String, completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsGet), hub)
        
        
        let json_parameters: [String: AnyObject]  = [
            "type":self.getEndpointTypeString() as AnyObject,
            "function":function as AnyObject,
            "v":value as AnyObject,
            "node":self.node as AnyObject,
            "parameters":[] as AnyObject
            
        ]
        

        
         let encoding = JSONStringArrayEncoding(array: [json_parameters])
        
        
        Alamofire.request(endpoint,method: .post, parameters:[:], encoding: encoding,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let url = (json["url"]).rawString()
                    completion(false, url!)
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true, response_string!)
                    
                    
                    
                }
                
                
        }
        
        
        
        
    }
    
    func SetLevel(_ hub:Int,token:String,value:String,function:String, completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        
            let headers = [
                "Authorization": "JWT "+token,
                "Accept": "application/json"
            ]
            
            let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub)
            
            
            let json_parameters: [String: AnyObject]  = [
                "type":self.getEndpointTypeString() as AnyObject,
                "function":function as AnyObject,
                "v":value as AnyObject,
                "node":self.node as AnyObject,
                "parameters":[] as AnyObject
                
            ]
            

            
        Alamofire.request(endpoint,method:.post, parameters:json_parameters, encoding: JSONEncoding.default,headers: headers)
                .validate()
                .responseJSON { response  in
                    switch response.result {
                        
                    case .success:
                        
                        
                        completion( false,"")
                        
                        
                    case .failure:
                        let data = NSData(data: response.data!) as Data
                        var json = JSON(data: data)
                        let response_string = (json["ERROR"]).rawString()
                        completion(true,response_string!)
                        
                        
                        
                    }
                    
                    
            }
            
        
        
        
    }
    func SetLevel(_ hub:Int,token:String,value:String,function:String,parameters:String, completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub)
        
        
        let json_parameters: [String: AnyObject]  = [
            "type":self.getEndpointTypeString() as AnyObject,
            "function":function as AnyObject,
            "v":value as AnyObject,
            "node":self.node as AnyObject,
            "parameters":parameters as AnyObject
            
        ]
 
        
        Alamofire.request(endpoint,method:.post, parameters:json_parameters, encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    
                    completion(false,"")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                    
                }
                
                
        }
        
        
        
        
    }
    
    

    func setValue(_ hub:Int,token:String,value:String, completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
    

        let parameters = [AnyObject]()
    
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub)
        
        
        let json_parameters: [String: AnyObject]  = [
            "type":self.getEndpointTypeString() as AnyObject,
            "function":Endpoint.GetFunctionValue(self.ui_class_command) as AnyObject,
            "v":value as AnyObject,
            "node":self.node as AnyObject,
            "parameters":parameters as AnyObject
            
        ]
        self.state = Int(value)!
        
         let encoding = JSONStringArrayEncoding(array: [json_parameters])
        
        Alamofire.request(endpoint,method:.post ,parameters:[:], encoding:encoding,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    
                    completion(false,"")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                    
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
    
    
    static func NameImages(name:String)->String{
        
        switch (name) {
        case "light_icon":
            return "light"
        case "light_2_icon":
            return "light2"
        case "light_3_icon":
            return "light3"
        case "light_4_icon":
            return "light4"
        case "light_5_icon":
            return "light5"
        case "hue_icon1":
            return "hue"
        case "hue_icon2":
            return "hue2"
        case "music_icon":
            return "sonos"
        case "music_2_icon":
            return "music"
        case "music_3_icon":
            return "music2"
        case "music_4_icon":
            return "music3"
        case "music_5_icon":
            return "music4"
        case "power_outlet_icon":
            return "power-outlet"
        case "power_outlet_2_icon":
            return "power-outlet2"
        case "switch_icon":
            return "power-outlet3"
        case "tv_icon":
            return "power-outlet4"
        case "door_lock_icon":
            return "door-lock"
        case "door_lock_2_icon":
            return "door-lock2"
        case "shades_2_icon":
            return "shades"
        case "shades_2_icon":
            return "shades2"
        case "shades_3_icon":
            return "shades3"
        case "shades_4_icon":
            return "shades4"
        case "ac_icon":
            return "temperature"
        case "temperature_icon":
            return "temperature2"
        case "sensor_icon":
            return "sensor"
        case "alarm_icon":
            return "alarm"
        case "alarm_2_icon":
            return "alarm2"
        case "alarm_3_icon":
            return "alarm3"
        case "battery_icon":
            return "battery"
        case "coffee-maker":
            return "cofee-maker"
        case "door_icon":
            return "door"
        case "door_2_icon":
            return "door2"
        case "energy_icon":
            return "energy"
        case "energy_2_icon":
            return "energy2"
        case "energy_sensor_icon":
            return "energy3"
        case "power_icon":
            return "energy4"
        case "lamp_icon":
            return "lamp"
        case "lamp_2_icon":
            return "lamp2"
        case "lamp_3_icon":
            return "lamp3"
        case "movement_sensor_icon":
            return "movement-sensor"
        case "movement_sensor_2_icon":
            return "movement-sensor2"
        case "movement_sensor_3_icon":
            return "movement-sensor3"
        case "movement_sensor_4_icon":
            return "movement-sensor4"
        case "open_close_sensor_icon":
            return "open-close-sensor"
        case "open_close_sensor_2_icon":
            return "open-close-sensor2"
        case "open_close_sensor_3_icon":
            return "open-close-sensor3"
        case "water_icon":
            return "water"
        case "water_2_icon":
            return "water2"
        case "water_3_icon":
            return "water3"
        default:
            return "light_icon"
            
        }
        
        
        
    }
    

    func GetFunctionValue()->String{
        return Endpoint.GetFunctionValue(self.ui_class_command)
    
    }
    
    static func GetFunctionValue(_ ui_class_command:String)->String{
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

            default:
                return "zwif_basic_set" //TODOS los dispositivos es binario (0,255)
                
                
        }
    }
    
    
    static func ConvertType(_ type:String)->EndPointType{
    
        if(type == "wifi"){
            return EndPointType.wifi
        
        }else{
            return EndPointType.zwave
        }
    
    }
    func getEndpointTypeString()->String{
        if(self.endpoint_type == EndPointType.wifi){
            return "wifi"
        }else{
            return "zwave"
        }
    
    }
    
    
    func GetPlayListSonos(completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        let hub:Int = (ArSmartApi.sharedApi.hub?.hid)!
        let token:String = ArSmartApi.sharedApi.getToken()
        
        getValueSonos(hub, token: token, function: "get_sonos_playlists", parameters: [:]) { (IsError, result) in
            if(IsError){
                print("Error")
                completion(IsError,result)
            }else{
                print("No Error")
                //TODO: Check Url
                self.GetList(token, url: result, completion: { (IsError, result) in
                    completion(IsError,result)
                })
                
                
            }
        }
        
        
        
    }
    
    
    func GetInfoSonos(completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        let hub:Int = (ArSmartApi.sharedApi.hub?.hid)!
        let token:String = ArSmartApi.sharedApi.getToken()
        
        getValueSonos(hub, token: token, function: "get_ui_info", parameters: [:]) { (IsError, result) in
            if(IsError){
                print("Error")
                completion(IsError,result)
            }else{
                print("No Error")
                //TODO: Check Url
                self.GetInfo(token, url: result, completion: { (IsError, result) in
                    completion(IsError,result)
                })
                
                
            }
        }
        
        
        
    }
    
    
    func GetList(_ token:String, url:String,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        Alamofire.request(ArSmartApi.sharedApi.ApiUrl(url), method:.get ,encoding:JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON {
                response  in
                switch response.result {
                    
                case .success:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let status = (json["status"]).rawString()

                    if(status == "processing"){
                        print("Processing..")
                        self.GetList(token, url: url, completion: { (IsError, result) in
                            completion(IsError,result)
                        })
                    }else{
                        let data = NSData(data: response.data!) as Data
                        var json = JSON(data: data)
                        let response_string = (json["response"][0]["title"]).rawString()
                        completion(false,response_string!)
                    }
                    
                    break
                    
                    
                case .failure:
                    print("error..")
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    
                    completion(true,response_string!)
                    
                    
                }
                
        }
        
    }
    func GetInfo(_ token:String, url:String,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        Alamofire.request(ArSmartApi.sharedApi.ApiUrl(url), method:.get ,encoding:JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON {
                response  in
                switch response.result {
                    
                case .success:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let status = (json["status"]).rawString()
                    
                    if(status == "processing"){
                        print("Processing..")
                        self.GetInfo(token, url: url, completion: { (IsError, result) in
                            completion(IsError,result)
                        })
                    }else{

                        completion(false,"")
                    }
                    
                    break
                    
                    
                case .failure:
                    print("error..")
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    
                    completion(true,response_string!)
                    
                    
                }
                
        }
        
    }
    
    //TODO: Sonos
    func playSonos(_ hub:Int,token:String,parameters:[String:AnyObject], completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        setValueSonos(hub, token: token, function: "play", parameters: parameters) { (IsError, result) in
            completion(IsError,result)
        }
    }
    func pauseSonos(_ hub:Int,token:String,parameters:[String:AnyObject], completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        setValueSonos(hub, token: token, function: "pause", parameters: parameters) { (IsError, result) in
            completion(IsError,result)
        }
    }
    func nextSonos(_ hub:Int,token:String,parameters:[String:AnyObject], completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        setValueSonos(hub, token: token, function: "play_next", parameters: parameters) { (IsError, result) in
            completion(IsError,result)
        }
    }
    func prevSonos(_ hub:Int,token:String,parameters:[String:AnyObject], completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        setValueSonos(hub, token: token, function: "play_previous", parameters: parameters) { (IsError, result) in
            completion(IsError,result)
        }
    }
    func setVomuneSonos(_ hub:Int,token:String,parameters:[String:AnyObject], completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        setValueSonos(hub, token: token, function: "set_volume", parameters: parameters) { (IsError, result) in
            completion(IsError,result)
        }
    }
    
    func setValueSonos(_ hub:Int,token:String,function:String,parameters:[String:AnyObject], completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        


        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub)
        
        
        let json_parameters: [String: AnyObject]  = [
            "type":self.getEndpointTypeString() as AnyObject,
            "target":"sonos" as AnyObject,
            "ip":ip_address as AnyObject,
            "function":function as AnyObject,
            "parameters":parameters as AnyObject
            
        ]
        

        
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JWT "+token, forHTTPHeaderField: "Authorization")
        

        
        request.httpBody = try! JSONSerialization.data(withJSONObject: [json_parameters])
        
        
        
        //Alamofire.request(endpoint,method:.post, parameters:array, encoding:JSONEncoding.default,headers: headers)
            Alamofire.request(request)
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    completion(false,"")
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(false,response_string!)
                    
                    
                    
                }
                
                
        }
        
        
        
        
    }
    
    
    func getValueSonos(_ hub:Int,token:String,function:String,parameters:[String:AnyObject], completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsGet), hub)
        
        
        let json_parameters: [String: AnyObject]  = [
            "type":self.getEndpointTypeString() as AnyObject,
            "target":"sonos" as AnyObject,
            "ip":ip_address as AnyObject,
            "function":function as AnyObject,
            "parameters":parameters as AnyObject
            
        ]
        
        
        
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JWT "+token, forHTTPHeaderField: "Authorization")
        
        
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: [json_parameters])
        
        
        
        //Alamofire.request(endpoint,method:.post, parameters:array, encoding:JSONEncoding.default,headers: headers)
        Alamofire.request(request)
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let url = (json["url"]).rawString()
                    completion(false,url!)
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(false,response_string!)
                    
                    
                    
                }
                
                
        }
        
        
        
        
    }
        
    func isLevel()->Bool{
        switch(self.ui_class_command){
            
        case "ui-level-light-zwave":
            return true
        case "ui-switch-multilevel-zwave":
            return true
        case "ui-switch-multilevel-zwave":
            return true
        default:
            return false
            
            
        }
    
    }
    
    func isSonos()->Bool{
        switch(self.ui_class_command){
            
        case "ui-sonos":
            return true
            
        default:
            return false
            
            
        }
        
    }
    func isHue()->Bool{
        switch(self.ui_class_command){
            
        case "ui-hue":
            return true
            
        default:
            return false
            
            
        }
        
    }
    
    func isSwitch()->Bool{
        switch(self.ui_class_command){
            
            
            case "ui-binary-outlet-zwave":
                return true
            case "ui-binary-light-zwave":
                return true
            case "ui-sensor-open-close-zwave":
                return true
            case "ui-lock-zwave":
                return true
            case "ui-switch-binary-zwave":
                return true

            
            default:
                return false
            
            
            }
        
    }
    
    
    func RequestRemoveZWaveToken(_ token:String,hub:Int,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        
        
    
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.RemoveZWave), hub)
        
        
        
        
        
        Alamofire.request(endpoint, method:.post,encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let url = (json["url"]).rawString()
                    //completion(IsError:true,result: url!)
                    self.WaitForZwaveResponse(token, url: url!, completion: { (IsError, result) in
                        completion(IsError, result)
                    })
                    break
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["detail"]).rawString()
                    completion(true,response_string!)
                    break
                    
                }
                
                
        }
        
        
        
        
    }
    
    func WaitForZwaveResponse(_ token:String, url:String,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        Alamofire.request(ArSmartApi.sharedApi.ApiUrl(url), method:.get,encoding:  JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON {
                response  in
                switch response.result {
                    
                case .success:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let status = (json["status"]).rawString()
                    
                    if(status == "processing"){
                        print("Processing..")
                        _ = Timer.every(2.seconds) {
                            (timer: Timer) in
                            // do something
                            
                            self.WaitForZwaveResponse(token,url: url, completion: { (IsError, result) in
                                completion(IsError,result)
                            })
                            
                            timer.invalidate()
                            
                        }
                        
                    }else if(status == "done"){
                        print("Done..")
                        let data = NSData(data: response.data!) as Data
                        _ = JSON(data: data)
                        completion(false,"")
                        
                    }
                    

                    

                case .failure:
                    print("error..")
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    
                    completion(true,response_string!)
                    
                    
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
