//
//  DeviceManager.swift
//  Living
//
//  Created by Nelson FB on 19/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftyTimer

class DeviceManager{

    var devices = [Device]()
    var request_type = ""
    
    
    
    
    /**
     Request for adding a Wifi device
     
     - parameter token: user token
     
     - parameter hub: hub id
     
     - parameter completion:  Callback function for completion, **return IsError = True if there is an error, false otherwise**
     
     */
    func RequestAddWifiToken(token:String,hub:Int,completion: (IsError:Bool,result: String, Devices:[EndpointResponse]) -> Void){
            
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]

        self.request_type = "wifi"
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.AddWifi), hub)
        Alamofire.request(.POST,endpoint,encoding: .JSON,headers: headers)
        .validate()
        .responseJSON {
            response  in
                    switch response.result {
                        
                    case .Success:
                        let data = NSData(data: response.data!)
                        var json = JSON(data: data)
                        let url = (json["url"]).rawString()
                        //completion(IsError:true,result: url!)
                        self.AvailableDevices(token, url: url!, completion: { (IsError, result,devices) in
                            completion(IsError: IsError,result: result,Devices: devices)
                        })
                        break
                        
                        
                    case .Failure:
                        let data = NSData(data: response.data!)
                        var json = JSON(data: data)
                        let response_string = (json["detail"]).rawString()
                        completion(IsError:true,result: response_string!, Devices:[])
                        break
                        
                    }
                    
                    
            }
            
    }
    func RequestAddWifiRequest(token:String,url:String,completion: (IsError:Bool,result: String) -> Void){
        
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
                    let url = (json["url"]).rawString()
                    completion(IsError:true,result: url!)
                    
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
    func RequestAddZWaveToken(token:String,hub:Int,completion: (IsError:Bool,result: String, Devices:[EndpointResponse]) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        self.request_type = "zwave"
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.AddZWave), hub)
        Alamofire.request(.POST,endpoint,encoding: .JSON,headers: headers)
            .validate()
            .responseJSON {
                response  in
                switch response.result {
                    
                case .Success:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let url = (json["url"]).rawString()
                    //completion(IsError:true,result: url!)
                    self.AvailableDevices(token, url: url!, completion: { (IsError, result, devices) in
                        completion(IsError: IsError,result: result, Devices: devices)
                    })
                    break
                    
                    
                case .Failure:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let response_string = (json["detail"]).rawString()
                    completion(IsError:true,result: response_string!, Devices: [])
                    break
                    
                }
                
                
        }
        
    }
    func RequestAddZWaveRequest(token:String,url:String,completion: (IsError:Bool,result: String) -> Void){
        
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
                    let url = (json["url"]).rawString()
                    completion(IsError:true,result: url!)
                    
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
    
    
    
    func AvailableDevices(token:String, url:String,completion: (IsError:Bool,result: String, Devices:[EndpointResponse]) -> Void){
        
        
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
                            
                            self.AvailableDevices(token,url: url, completion: { (IsError, result, devices) in
                                completion(IsError:IsError,result:result, Devices: devices)
                            })
                            
                            timer.invalidate()
                            
                        }
                    
                    }else if(status == "done"){
                        print("Done..")
                        let data = NSData(data: response.data!)
                        var json = JSON(data: data)
                        
                        var devices = [EndpointResponse]()
                        
                        for endpoint_response in  json["response"].arrayObject!{
                            let uid = endpoint_response["uid"]
                            let manufacturer_name = String(endpoint_response["manufacturer_name"])
                            let port = endpoint_response["port"]
                            let endpoint_type = endpoint_response["endpoint_type"]
                            let ip_address = endpoint_response["ip_address"]
                            let ui_class_command = endpoint_response["ui_class_command"]
                            let name = endpoint_response["name"]
                            
                            let object = EndpointResponse()
                            object.uid = uid as! String
                            object.endpoint_type = endpoint_type as! String
                            object.ui_class_command = ui_class_command as! String
                            object.manufacturer_name = manufacturer_name
                            //endpoint_response.category = category as! String
                            
                            
                            if(self.request_type == "wifi"){
                                object.ip_address = ip_address as! String
                                object.port = port as! String
                                object.name = name as! String
                            }else{
          
                                let name = String(format:"Nuevo dispositivo ZWave encontrado: %@", uid as! String)
                                object.name = name
                            }
                            

                            
                            
                            devices.append(object)
                        
                        }
         

                        
                        

                        
                        
                        
                        completion(IsError:false,result:"",Devices: devices)
                    }
                    
                    
  
                    
                    break
                    
                    
                case .Failure:
                    print("error..")
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    
                    completion(IsError:true,result:response_string!, Devices: [])
                    break
                    
                }
                
                
        }

        
        
        
        

    }


}