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
    func RequestAddWifiToken(_ token:String,hub:Int,completion: @escaping (_ IsError:Bool,_ result: String, _ Devices:[EndpointResponse]) -> Void){
            
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]

        self.request_type = "wifi"
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.AddWifi), hub)
        Alamofire.request(endpoint, method:.post,encoding: JSONEncoding.default,headers: headers)
        .validate()
        .responseJSON {
            response  in
                    switch response.result {
                        
                    case .success:
                        let data = NSData(data: response.data!) as Data
                        var json = try! JSON(data: data)
                        let url = (json["url"]).rawString()
                        //completion(IsError:true,result: url!)
                        self.AvailableDevices(token, url: url!, completion: { (IsError, result,devices) in
                            completion( IsError,result,devices)
                        })
                        break
                        
                        
                    case .failure:
                        let data = NSData(data: response.data!) as Data
                        var json = try! JSON(data: data)
                        let response_string = (json["detail"]).rawString()
                        completion(true,response_string!,[])
                        break
                        
                    }
                    
                    
            }
            
    }
    func RequestAddWifiRequest(_ token:String,url:String,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        

        Alamofire.request(ArSmartApi.sharedApi.ApiUrl(url), method:.get,encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON {
                response  in
                switch response.result {
                    
                case .success:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let url = (json["url"]).rawString()
                    completion(true, url!)
                    
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
    func RequestAddZWaveToken(_ token:String,hub:Int,completion: @escaping (_ IsError:Bool,_ result: String, _ Devices:[EndpointResponse]) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        self.request_type = "zwave"
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.AddZWave), hub)
        Alamofire.request(endpoint, method:.post,encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON {
                response  in
                switch response.result {
                    
                case .success:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let url = (json["url"]).rawString()
                    //completion(IsError:true,result: url!)
                    self.AvailableDevices(token, url: url!, completion: { (IsError, result, devices) in
                        completion(IsError,result, devices)
                    })
                    break
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let response_string = (json["detail"]).rawString()
                    completion(true, response_string!, [])
                    break
                    
                }
                
                
        }
        
    }
    
    func RequestRemoveZWaveToken(_ token:String,hub:Int,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        

        
        self.request_type = "zwave"
        
        
        
        
        
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
                    var json = try! JSON(data: data)
                    let url = (json["url"]).rawString()
                    //completion(IsError:true,result: url!)
                    self.WaitForZwaveResponse(token, url: url!, completion: { (IsError, result) in
                        completion(IsError,result)
                    })
                    break
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let response_string = (json["detail"]).rawString()
                    completion(true, response_string!)
                    break
                    
                }
                
                
        }
        
        

        
    }
    
    
    func RequestAddZWaveRequest(_ token:String,url:String,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        Alamofire.request(ArSmartApi.sharedApi.ApiUrl(url), method:.get,encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON {
                response  in
                switch response.result {
                    
                case .success:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let url = (json["url"]).rawString()
                    completion(true,url!)
                    
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
    
    
    
    func AvailableDevices(_ token:String, url:String,completion: @escaping (_ IsError:Bool,_ result: String, _ Devices:[EndpointResponse]) -> Void){
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        Alamofire.request(ArSmartApi.sharedApi.ApiUrl(url), method:.get,encoding:JSONEncoding.default,headers: headers)
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
                        Timer.every(2.seconds) {
                            (timer: Timer) in
                            // do something
                            
                            self.AvailableDevices(token,url: url, completion: { (IsError, result, devices) in
                                completion(IsError,result, devices)
                            })
                            
                            timer.invalidate()
                            
                        }
                    
                    }else if(status == "done"){
                        print("Done..")
                        let data = NSData(data: response.data!) as Data
                        var json = try! JSON(data: data)
                        
                        var devices = [EndpointResponse]()
                        
                        for endpoint_response in  json["response"].arrayValue{
                            let uid = endpoint_response["uid"].stringValue
                            let manufacturer_name = endpoint_response["manufacturer_name"].stringValue
                            let port = endpoint_response["port"].intValue
                            let node = endpoint_response["node"].intValue
                            let endpoint_type = endpoint_response["endpoint_type"].stringValue
                            let ip_address = endpoint_response["ip_address"].stringValue
                            let ui_class_command = endpoint_response["ui_class_command"].stringValue
                            let name = endpoint_response["name"].stringValue
                            
                            let category_code = endpoint_response["category"]["code"].intValue
                            let category_description = endpoint_response["category"]["description"].stringValue
                            
                            let object = EndpointResponse()
                            object.uid = uid
                            object.node = node
                            object.endpoint_type = endpoint_type
                            object.ui_class_command = ui_class_command
                            object.manufacturer_name = manufacturer_name
                            //endpoint_response.category = category as! String
                            object.category = CategoryEndpoint(code:category_code,description:category_description)
                            
                            if(self.request_type == "wifi"){
                                object.ip_address = ip_address
                                object.port = String(port)
                                object.name = name
                            }else{
          
                                let name = String(format:"Nuevo dispositivo ZWave encontrado: %@", uid)
                                object.name = name
                            }
                            

                            
                            
                            devices.append(object)
                        
                        }
         

                        
                        

                        
                        
                        
                        completion(false,"",devices)
                    }
                    
                    
  
                    
                    break
                    
                    
                case .failure:
                    print("error..")
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    
                    completion(true,response_string!, [])
                    break
                    
                }
                
                
        }

        
        
        
        

    }
    
    func WaitForZwaveResponse(_ token:String, url:String,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        Alamofire.request(ArSmartApi.sharedApi.ApiUrl(url), method:.get ,encoding:JSONEncoding.default, headers: headers)
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
                        Timer.every(2.seconds) {
                            (timer: Timer) in
                            // do something
                            
                            self.WaitForZwaveResponse(token,url: url, completion: { (IsError, result) in
                                completion(IsError,result)
                            })
                            
                            timer.invalidate()
                            
                        }
                        
                    }else if(status == "done"){
                        //print("Done..")
                        //let data = NSData(data: response.data!) as Data
                        
                        completion(false,"Done")
                        
                    }else{
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


}
