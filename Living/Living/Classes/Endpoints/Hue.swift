//
//  Hue.swift
//  Living
//
//  Created by Nelson FB on 1/09/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



class Hue{
    
    var lights:[HueLight]
    var groups:[HueGroup]
    var endpoint:Endpoint

    
    init(){
        lights = [HueLight]()
        groups = [HueGroup]()
        endpoint = Endpoint()
    }
    
    func RequestHueInfo(_ token:String,hub:Int,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint_url = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsGet), hub)
        
        
        
        let json_parameters: [String: AnyObject]  = [
            "type":endpoint.getEndpointTypeString() as AnyObject,
            "target":"hue" as AnyObject,
            "ip":endpoint.ip_address as AnyObject,
            "function":"get_ui_info" as AnyObject,
            "parameters":[AnyObject]() as AnyObject,
            
        ]

        
        
        Alamofire.request(endpoint_url, method: .post, parameters:json_parameters, encoding: JSONEncoding.default, headers: headers )
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let url = (json["url"]).rawString()
                    //completion(IsError:true,result: url!)
                    self.WaitForHueResponse(token, url: url!, completion: { (IsError, result) in
                        completion(IsError,result)
                    })
                    break
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let response_string = (json["detail"]).rawString()
                    completion(true,response_string!)
                    break
                    
                }
                
                
        }
        
        
        
        
    }
    func WaitForHueResponse(_ token:String, url:String,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        Alamofire.request(ArSmartApi.sharedApi.ApiUrl(url), method:.get, encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON {
                response  in
                switch response.result {
                    
                case .success:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let status = (json["status"]).rawString()
                    
                    if(status == "processing"){
                        print("Processing..")
                        _ = Timer.every(2.seconds) {
                            (timer: Timer) in
                            // do something
                            
                            self.WaitForHueResponse(token,url: url, completion: { (IsError, result) in
                                completion(IsError,result)
                            })
                            
                            timer.invalidate()
                            
                        }
                        
                    }else if(status == "done"){
                        print("Done..")
                        let data = NSData(data: response.data!) as Data
                        var json = try! JSON(data: data)
                        //TODO:Obtener los dos grupos y luces individuales
                        print("Aqui vamos a obtener los hue")
                        let groups = json["response"]["groups"]
                        let lights = json["response"]["lights"]
                        self.getAllLights(lights)
                        self.getAllLightsinGroup(groups)
                        completion(false,"")
                    }
                    
                    
                    
                    
                case .failure:
                    print("error..")
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    
                    completion(true,response_string!)
                    
                    
                }
                
                
        }
        
        
        
        
        
        
    }
    
    func getAllLights(_ json:JSON){
    
        for (_,subJson):(String, JSON) in json {
            //Do something you want
                let light_id = subJson["light_id"].intValue
                let name = subJson["name"].stringValue
                let reachable = subJson["reachable"].boolValue
                let swversion = subJson["swversion"].stringValue
                let type = subJson["type"].stringValue
                let on = subJson["on"].boolValue
                let colorMode = subJson["colorMode"].stringValue
                let effect = subJson["effect"].stringValue
                let manufacturername = subJson["manufacturername"].stringValue
                let uniqueid = subJson["uniqueid"].stringValue
                let saturation = subJson["saturation"].doubleValue
                let modelid = subJson["modelid"].stringValue
                let brightness = subJson["brightness"].doubleValue
                let alert = subJson["alert"].stringValue
                let hue = subJson["hue"].doubleValue
                let xy = (subJson["xy"][0].doubleValue,subJson["xy"][1].doubleValue)
                
                let l = HueLight(light_id:light_id,reachable:reachable,swversion:swversion,type:type,colorMode:colorMode,on:on,effect:effect,manufacturername:manufacturername,uniqueid:uniqueid,xy:xy,saturation:saturation,name:name,modelid:modelid,brightness:brightness,alert:alert,hue:hue)
                
                self.lights.append(l)
                
                /*{
                 "saturation" : 0,
                 "uniqueid" : "00:17:88:01:00:c2:9e:e7-0b",
                 "swversion" : "66009461",
                 "on" : false,
                 "manufacturername" : "Philips",
                 "alert" : "none",
                 "modelid" : "LLC011",
                 "colormode" : "hs",
                 "reachable" : true,
                 "hue" : 0,
                 "effect" : "none",
                 "brightness" : 127,
                 "xy" : [
                 0.435,
                 0.405
                 ],
                 "light_id" : 1,
                 "name" : "LivingColors 1",
                 "type" : "Color light"
                 }*/
                
            
            
            
        }
    
    
    }
    func getAllLightsinGroup(_ json:JSON){
    
    
        
        
        //If json is .Array
        //The `index` is 0..<json.count's string value
        for (_,subJson):(String, JSON) in json {
            //Do something you want
            
            let group = HueGroup()
            group.group_id = subJson["group_id"].intValue
            group.name = subJson["name"].stringValue
            
            for (_,subJson2):(String, JSON) in subJson["lights"] {
                //Do something you want
                
                print("test")
                let light_id = subJson2["light_id"].intValue
                let name = subJson2["name"].stringValue
                let reachable = subJson2["reachable"].boolValue
                let swversion = subJson2["swversion"].stringValue
                let type = subJson2["type"].stringValue
                let on = subJson2["on"].boolValue
                let colorMode = subJson2["colorMode"].stringValue
                let effect = subJson2["effect"].stringValue
                let manufacturername = subJson2["manufacturername"].stringValue
                let uniqueid = subJson2["uniqueid"].stringValue
                let saturation = subJson2["saturation"].doubleValue
                let modelid = subJson2["modelid"].stringValue
                let brightness = subJson2["brightness"].doubleValue
                let alert = subJson2["alert"].stringValue
                let hue = subJson2["hue"].doubleValue
                let xy = (subJson2["xy"][0].doubleValue,subJson2["xy"][1].doubleValue)
                
                let l = HueLight(light_id:light_id,reachable:reachable,swversion:swversion,type:type,colorMode:colorMode,on:on,effect:effect,manufacturername:manufacturername,uniqueid:uniqueid,xy:xy,saturation:saturation,name:name,modelid:modelid,brightness:brightness,alert:alert,hue:hue)
                l.group_id = group.group_id
                group.lights.append(l)
                
                /*{
                    "saturation" : 0,
                    "uniqueid" : "00:17:88:01:00:c2:9e:e7-0b",
                    "swversion" : "66009461",
                    "on" : false,
                    "manufacturername" : "Philips",
                    "alert" : "none",
                    "modelid" : "LLC011",
                    "colormode" : "hs",
                    "reachable" : true,
                    "hue" : 0,
                    "effect" : "none",
                    "brightness" : 127,
                    "xy" : [
                    0.435,
                    0.405
                    ],
                    "light_id" : 1,
                    "name" : "LivingColors 1",
                    "type" : "Color light"
                }*/
                
            }
            
            self.groups.append(group)
        }
    
    
    
    }

    func turn_all_on(_ hub:Int,token:String,rgb:(Double,Double,Double), completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        setValueHue(hub, token: token, function: "turn_on_all_lights") { (IsError, result) in
            completion(IsError,result)
        }
    }
    func turn_all_off(_ hub:Int,token:String,rgb:(Double,Double,Double), completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        setValueHue(hub, token: token, function: "turn_off_all_lights") { (IsError, result) in
            completion(IsError,result)
        }
    }
    
    
    
    func setValueHue(_ hub:Int,token:String,function:String, completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub)
        

        
        //[{"type":"wifi","target":"hue","ip":"<IP_DISPOSITIVO>","function":"set_color_to_light_by_id","parameters":["r":100,"g":100,"b":100]}]
        

        
        let json_parameters: [String: AnyObject]  = [
            "type":"wifi" as AnyObject,
            "target":"hue" as AnyObject,
            "ip":self.endpoint.ip_address as AnyObject,
            "function":function as AnyObject,
            "parameters":[AnyObject]() as AnyObject
            
        ]

    
        Alamofire.request(endpoint,method:.post, parameters:json_parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    
                    completion( false, "")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                    
                }
                
                
        }
        
        
        
        
    }
    // Los siguientes metodos se realizaron solo para propositos de prueba
    
    
    func RequestHueInfo_Test(_ token:String,hub:Int,completion: (_ IsError:Bool,_ result: String) -> Void){
        
        
       /* {
            "saturation" : 0,
            "uniqueid" : "00:17:88:01:00:c2:9e:e7-0b",
            "swversion" : "66009461",
            "on" : false,
            "manufacturername" : "Philips",
            "alert" : "none",
            "modelid" : "LLC011",
            "colormode" : "hs",
            "reachable" : true,
            "hue" : 0,
            "effect" : "none",
            "brightness" : 127,
            "xy" : [
            0.435,
            0.405
            ],
            "light_id" : 1,
            "name" : "LivingColors 1",
            "type" : "Color light"
        }*/
        
        let hue_light_1 = HueLight(light_id:1,reachable:true,swversion: "66009461",type:"Color light",colorMode:"hs",on:false,effect:"none",manufacturername:"Philips",uniqueid:"00:17:88:01:00:c2:9e:e7-0b",xy:(0.435,0.405),saturation:0,name:"[Lights]LivingColors 1",modelid:"LLC011",brightness:127,alert:"none",hue:0)
        
        let hue_light_2 = HueLight(light_id:1,reachable:true,swversion: "66009461",type:"Color light",colorMode:"hs",on:false,effect:"none",manufacturername:"Philips",uniqueid:"00:17:88:01:00:c2:9e:e7-0b",xy:(0.435,0.405),saturation:0,name:"[Group]LivingColors 1",modelid:"LLC011",brightness:127,alert:"none",hue:0)
        
        
        let group = HueGroup()
        group.group_id = 1
        group.name = "Grupo 1 - Test"
        group.lights.append(hue_light_2)
        
        self.lights.append(hue_light_1)
        self.groups.append(group)
        completion(false,"")
        
    }
    
    
    func groupName(_ index:Int)->String{
        if(self.groups.count<index && index >= 0){
            return self.groups[index].name
        }else{
            return ""
        }
    }
    
    func groupLightsCount(_ index:Int)->Int{
        if(self.groups.count>index){
            return self.groups[index].lights.count
        }else{
            return 0
        }
    }
}
