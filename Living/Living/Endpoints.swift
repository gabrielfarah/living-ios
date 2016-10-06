//
//  Endpoints.swift
//  Living
//
//  Created by Nelson FB on 26/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Endpoints{

    var endpoints = [Endpoint]()
    
    init(){
    }
    

    func add(_ endPoint:Endpoint){
        self.endpoints.append(endPoint)
    }
    
    func count()->Int{
        
        return self.endpoints.count
        
    }
    
    func noSensorEndpoints()->[Endpoint]{
    
    
        return endpoints.filter { $0.isSensor() ==  false }
    
    }
    
    func inRoom(room:Room)->[Endpoint]{
        
        
        return endpoints.filter { $0.room.description ==  room.description }
        
    }
    
    func objectAtIndex(_ index:Int)->Endpoint{
    
        return endpoints[index]
    }
    func setStateEndpoint(_ state:Int, node:Int){
        
        for endpoint:Endpoint in self.endpoints{
            print("Ednpoint Node: ",node)
            if(endpoint.node == node){
                endpoint.state = state
                
                print("Ednpoint Set: ",node,state)
            }
            
        }
    }
    
    
    func GetStatusZWavesDevicesTask(_ hub:Int,token:String, completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        GetStatusZWavesDevicesTaskUrl(hub, token: token) { (IsError, result) in
            if(!IsError){
            
                
                
   
                self.GetStatusZWavesDevicesTaskUrlResponse(hub, token: token, url: result, completion: {
                    (IsError, result) in
                    print("GetStatusZWavesDevicesTaskUrlResponse:"+result)
                    completion(IsError,result);
                })
                
                
                
                
                
                
                
            }else{
            
            }
        }
    
    }
    
    func GetStatusZWavesDevicesTaskUrl(_ hub:Int,token:String, completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
    

            
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsGet), hub)

        let  parameters: [String: String] = [:]
        let json_parameters: [String: AnyObject]  = [
            "type":"zwave" as AnyObject,
            "function":"zwnet_get_all_status" as AnyObject,
            "parameters":parameters as AnyObject
        
        ]

        let array = JSON([json_parameters])
    

        
        
        Alamofire.request(endpoint,method:.post, parameters:json_parameters, encoding: JSONEncoding.default,headers: headers)
                .validate()
                .responseJSON { response  in
                    switch response.result {
                        
                    case .success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            
                            
                            let url = json["url"].stringValue
                            completion(false,url)
                            
                   
                        }else{
                            completion(true,"")
                        }

                        
                    case .failure:
                        let data = NSData(data: response.data!) as Data
                        var json = JSON(data: data)
                        let response_string = (json["ERROR"]).rawString()
                        completion(true,response_string!)
                        
                        
                        
                    }
                    
                    
            }
            
        
    
    }
    
    func GetStatusZWavesDevicesTaskUrlResponse(_ hub:Int,token:String,url:String, completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint =  String(format:ArSmartApi.sharedApi.ApiUrl(url))
        
        Alamofire.request(endpoint, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let status = json["status"].stringValue
                        let url = json["url"].stringValue
                        if(status == "processing"){
                            print(status)
                            self.GetStatusZWavesDevicesTaskUrlResponse(hub, token: token,url:url, completion: { (IsError, result) in
                                completion(IsError,result)
                            })
                            
                            
                        }else{
                            
                           /* ▿ SUCCESS: {
                                response =     {
                                    ERROR = "The Z-Wave network is currently down. Reboot the hub and try again";
                                };
                                status = done;
                            }*/
                           //if(response.result)
                            if let error = json["response"]["ERROR"].string{
                                 completion(true,error)
                            }else{
                            //TODO: ObtenerJSON y asignar estados.
                                let devices_status =  json["response"]
                                for (index,subJson):(String,JSON) in devices_status{
                                
                                    
                                    
                                    //Node
                                    let node = subJson["node"].intValue
                                    let state = subJson["state"][0].intValue
                                    print("index %d",index)
                                    self.setStateEndpoint(state, node: node)

                                    
                                    
                                }
                                completion(false, "")
                            }
                            
                           
                        }
                        
                        
                    }else{
                        completion(true,"")
                    }
                    
                    
                    
                    
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                    
                }

    }
    

    
    
    func AvailableStatus(_ token:String, url:String,completion: @escaping (_ IsError:Bool,_ result: String, _ Devices:[EndpointResponse]) -> Void){
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        Alamofire.request(ArSmartApi.sharedApi.ApiUrl(url),method:.get, encoding:JSONEncoding.default, headers: headers)
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
                        var timer = Timer.every(2.seconds) {
                            (timer: Timer) in
                            // do something
                            
                            AvailableStatus(token,url: url, completion: { (IsError, result, devices) in
                                completion(IsError,result, devices)
                            })
                            
                            timer.invalidate()
                            
                        }
                        
                    }else if(status == "done"){
                        print("Done..")
                        let data = NSData(data: response.data!) as Data
                        var json = JSON(data: data)
                        
                        
                        
                        
                        
                        
                        completion(false,"", [])
                    }
                    
                    
                    
                    
                    break
                    
                    
                case .failure:
                    print("error..")
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    
                    completion(true,response_string!,[])
                    break
                    
                }
                
                
        }
    
    
    }

}
}
