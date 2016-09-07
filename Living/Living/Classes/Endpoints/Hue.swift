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
    
    func RequestHueInfo(token:String,hub:Int,completion: (IsError:Bool,result: String) -> Void){
        
        
        
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint_url = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsGet), hub)
        
        
        
        let json_parameters: [String: AnyObject]  = [
            "type":endpoint.getEndpointTypeString(),
            "target":"hue",
            "ip":endpoint.ip_address,
            "function":"get_ui_info",
            "parameters":[]
            
        ]
        
        let array = JSON([json_parameters])
        
        
        
        Alamofire.request(.POST,endpoint_url,headers: headers, parameters:[:], encoding:.Custom({convertible, params in
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
                    //completion(IsError:true,result: url!)
                    self.WaitForHueResponse(token, url: url!, completion: { (IsError, result) in
                        completion(IsError: IsError,result: result)
                    })
                    break
                    
                    
                case .Failure:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let response_string = (json["detail"]).rawString()
                    completion(IsError:true,result: response_string!)
                    break
                    
                }
                
                
        }
        
        
        
        
    }
    func WaitForHueResponse(token:String, url:String,completion: (IsError:Bool,result: String) -> Void){
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        Alamofire.request(.GET,ArSmartApi.sharedApi.ApiUrl(url),encoding: .JSON,headers: headers)
            .validate()
            .responseJSON {
                response  in
                switch response.result {
                    
                case .Success:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let status = (json["status"]).rawString()
                    
                    if(status == "processing"){
                        print("Processing..")
                        var timer = NSTimer.every(2.seconds) {
                            (timer: NSTimer) in
                            // do something
                            
                            self.WaitForHueResponse(token,url: url, completion: { (IsError, result) in
                                completion(IsError:IsError,result:result)
                            })
                            
                            timer.invalidate()
                            
                        }
                        
                    }else if(status == "done"){
                        print("Done..")
                        let data = NSData(data: response.data!)
                        var json = JSON(data: data)
                        //TODO:Obtener los dos grupos y luces individuales
                        print("Aqui vamos a obtener los hue")
                        let groups = json["response"]["groups"]
                        let lights = json["response"]["lights"]
                        self.getAllLights(lights)
                        self.getAllLightsinGroup(groups)
                    }
                    
                    
                    completion(IsError:false,result:"")
                    
                case .Failure:
                    print("error..")
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    
                    completion(IsError:true,result:response_string!)
                    
                    
                }
                
                
        }
        
        
        
        
        
        
    }
    
    func getAllLights(json:JSON){
    
        for (index,subJson):(String, JSON) in json {
            //Do something you want
            

                
                print("test")
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
                let xy = (subJson["hue"][0].doubleValue,subJson["hue"][1].doubleValue)
                
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
    func getAllLightsinGroup(json:JSON){
    
    
        
        
        //If json is .Array
        //The `index` is 0..<json.count's string value
        for (index,subJson):(String, JSON) in json {
            //Do something you want
            
            var group = HueGroup()
            group.group_id = subJson["group_id"].intValue
            group.name = subJson["name"].stringValue
            
            for (index,subJson2):(String, JSON) in subJson["lights"] {
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
                let xy = (subJson2["hue"][0].doubleValue,subJson2["hue"][1].doubleValue)
                
                let l = HueLight(light_id:light_id,reachable:reachable,swversion:swversion,type:type,colorMode:colorMode,on:on,effect:effect,manufacturername:manufacturername,uniqueid:uniqueid,xy:xy,saturation:saturation,name:name,modelid:modelid,brightness:brightness,alert:alert,hue:hue)
                
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

    func turn_all_on(hub:Int,token:String,rgb:(Double,Double,Double), completion: (IsError:Bool,result: String) -> Void){
        setValueHue(hub, token: token, function: "turn_on_all_lights") { (IsError, result) in
            completion(IsError: IsError,result:result)
        }
    }
    func turn_all_off(hub:Int,token:String,rgb:(Double,Double,Double), completion: (IsError:Bool,result: String) -> Void){
        setValueHue(hub, token: token, function: "turn_off_all_lights") { (IsError, result) in
            completion(IsError: IsError,result:result)
        }
    }
    
    
    
    func setValueHue(hub:Int,token:String,function:String, completion: (IsError:Bool,result: String) -> Void){
        
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub)
        

        
        //[{"type":"wifi","target":"hue","ip":"<IP_DISPOSITIVO>","function":"set_color_to_light_by_id","parameters":["r":100,"g":100,"b":100]}]
        

        
        let json_parameters: [String: AnyObject]  = [
            "type":"wifi",
            "target":"hue",
            "ip":self.endpoint.ip_address,
            "function":function,
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