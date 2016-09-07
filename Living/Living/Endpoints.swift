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
    

    func add(endPoint:Endpoint){
        self.endpoints.append(endPoint)
    }
    
    func count()->Int{
        
        return self.endpoints.count
        
    }
    func objectAtIndex(index:Int)->Endpoint{
    
        return endpoints[index]
    }
    func setStateEndpoint(state:Int, node:Int){
        
        for endpoint:Endpoint in self.endpoints{
            print("Ednpoint Node: ",node)
            if(endpoint.node == node){
                endpoint.state = state
                
                print("Ednpoint Set: ",node,state)
            }
            
        }
    }
    
    
    func GetStatusZWavesDevicesTask(hub:Int,token:String, completion: (IsError:Bool,result: String) -> Void){
        
        GetStatusZWavesDevicesTaskUrl(hub, token: token) { (IsError, result) in
            if(!IsError){
            
                
                
   
                self.GetStatusZWavesDevicesTaskUrlResponse(hub, token: token, url: result, completion: {
                    (IsError, result) in
                    print("GetStatusZWavesDevicesTaskUrlResponse:"+result)
                    completion(IsError: IsError,result: result);
                })
                
                
                
                
                
                
                
            }else{
            
            }
        }
    
    }
    
    func GetStatusZWavesDevicesTaskUrl(hub:Int,token:String, completion: (IsError:Bool,result: String) -> Void){
    

            
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsGet), hub)

        let  parameters: [String: String] = [:]
        let json_parameters: [String: AnyObject]  = [
            "type":"zwave",
            "function":"zwnet_get_all_status",
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
                        if let value = response.result.value {
                            let json = JSON(value)
                            
                            
                            let url = json["url"].stringValue
                            completion(IsError: false,result:url)
                            
                            print("JSON: \(json)")
                        }else{
                            completion(IsError:true,result: "")
                        }
                        

                        
                        
                        
                        
                    case .Failure:
                        let data = NSData(data: response.data!)
                        var json = JSON(data: data)
                        let response_string = (json["ERROR"]).rawString()
                        completion(IsError:true,result: response_string!)
                        
                        
                        
                    }
                    
                    
            }
            
        
    
    }
    
    func GetStatusZWavesDevicesTaskUrlResponse(hub:Int,token:String,url:String, completion: (IsError:Bool,result: String) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint =  String(format:ArSmartApi.sharedApi.ApiUrl(url))
        
        Alamofire.request(.GET,endpoint,headers: headers, encoding:.JSON)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let status = json["status"].stringValue
                        let url = json["url"].stringValue
                        if(status == "processing"){
                            
                            self.GetStatusZWavesDevicesTaskUrlResponse(hub, token: token,url:url, completion: { (IsError, result) in
                                completion(IsError: IsError,result:result)
                            })
                            
                            
                        }else{
                            
                           /* ▿ SUCCESS: {
                                response =     {
                                    ERROR = "The Z-Wave network is currently down. Reboot the hub and try again";
                                };
                                status = done;
                            }*/
                           //if(response.result)
                            if(json["response"]["ERROR"]){
                                let error =  json["response"]["ERROR"].stringValue
                                 completion(IsError: true,result: error)
                            }else{
                            //TODO: ObtenerJSON y asignar estados.
                                let devices_status =  json["response"]
                                for (index,subJson):(String,JSON) in devices_status{
                                
                                    
                                    
                                    //Node
                                    let node = subJson["node"].intValue
                                    let state = subJson["state"][0].intValue
                                    print("index %d",index)
                                    self.setStateEndpoint(state, node: node)
                                    /*
                                    "sensor" : 0,
                                    "sleep_cap" : 0,
                                    "active" : "true",
                                    "node" : 11,
                                    "mainCC" : [
                                    25
                                    ],
                                    "state" : [
                                    0
                                    ]
*/
                                    
                                    
                                }
                                completion(IsError: true,result: "")
                            }
                            
                           
                        }
                        
                        
                    }else{
                        completion(IsError:true,result: "")
                    }
                    
                    
                    
                    
                    
                    
                case .Failure:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(IsError:true,result: response_string!)
                    
                    
                    
                }

    }
    

    
    
    func AvailableStatus(token:String, url:String,completion: (IsError:Bool,result: String, Devices:[EndpointResponse]) -> Void){
        
        
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
                            
                            AvailableStatus(token,url: url, completion: { (IsError, result, devices) in
                                completion(IsError:IsError,result:result, Devices: devices)
                            })
                            
                            timer.invalidate()
                            
                        }
                        
                    }else if(status == "done"){
                        print("Done..")
                        let data = NSData(data: response.data!)
                        var json = JSON(data: data)
                        
                        
                        
                        
                        
                        
                        completion(IsError:false,result:"",Devices: [])
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
}