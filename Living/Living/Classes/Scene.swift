//
//  Scene.swift
//  Living
//
//  Created by Nelson FB on 23/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Scene{

    var name:String = ""
    var sid:Int = 0
    var timed:Bool = false
    var order:Int = 0
    var payload:[Payload] = [Payload]()
    var image:String = ""
    
    
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
        self.name = ""
        self.sid=0
        self.payload = [Payload]()
        
    }
    
    init(name:String,id:Int){
        self.name = name
        self.sid=id
        self.payload = [Payload]()
        
    }
    
    
    init(name:String,id:Int, payload:[Payload]){
        self.name = name
        self.sid=id
        self.payload = payload
    
    }
    

    
    func save(_ token:String,hub:Int,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Modes), hub)
        var payload_array: [[String: AnyObject]] = [[String: AnyObject]]()
        for command:Payload in payload{
            payload_array.append(command.getDictionary())
        }
        
        
        
        let json_parameters: [String: AnyObject]  = [
            "name":self.name as AnyObject,
            "image":self.image as AnyObject,
            "payload":payload_array as AnyObject,
            "timed":self.timed as AnyObject
            
        ]
        
 
        
        
        Alamofire.request(endpoint,method:.post, parameters:json_parameters, encoding:JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    
                    completion( false, "")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = json["ERROR"].dictionary?.first
                    let final_string = response_string!.1[0].stringValue
                    
                    completion(true,final_string)
                    
                    
                    
                }
                
                
        }

    }
    
    func update(_ token:String,hub:Int,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Mode), hub, self.sid)
        var payload_array: [[String: AnyObject]] = [[String: AnyObject]]()
        for command:Payload in payload{
            payload_array.append(command.getDictionary())
        }
        
        
        
        let json_parameters: [String: AnyObject]  = [
            "name":self.name as AnyObject,
             "image":self.image as AnyObject,
            "payload":payload_array as AnyObject,
            "timed":self.timed as AnyObject
            
        ]
        

        
        
        
        Alamofire.request(endpoint, method:.put, parameters:json_parameters, encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    
                    completion(false, "")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    
                    if json["detail"].exists(){
                        
                        let response_string = json["detail"].stringValue

                        completion(true,response_string)
                    }else if json["ERROR"].exists(){
                        
                        let response_string = json["ERROR"].dictionary?.first
                        let final_string = response_string!.1[0].stringValue
                        
                        completion(true,final_string)
                    }
         
                    
                    
                    
                }
                
                
        }
        
    }
    
    
    func run(_ token:String,hub:Int,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub, self.sid)
        var payload_array: [[String: AnyObject]] = [[String: AnyObject]]()
        for command:Payload in payload{
            
            if(command.target == "sonos"){
                payload_array.append(command.getDictionaryIfIsSonos())
            }else if(command.target == "hue"){
                payload_array.append(command.getDictionaryIfIsHue())
            }else{
                        payload_array.append(command.getDictionary())
            }
            

        }
        
        
        let encoding = JSONStringArrayEncoding(array: payload_array)
        
        Alamofire.request(endpoint, method:.post, parameters:[:], encoding:encoding, headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    
                    completion(false,"")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = json["ERROR"]
                    let final_string = response_string.stringValue
                    
                    completion(true,final_string)
                    
                    
                    
                }
                
                
        }
        
    }
    
    func delete(_ token:String,hub:Int,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Mode),hub,self.sid)
        
        Alamofire.request(endpoint, method:.delete, encoding:  JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    
                    completion(false,"")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["detail"]).rawString()
                    completion(true, response_string!)
                    
                    
                    
                }
                
                
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
    

}
