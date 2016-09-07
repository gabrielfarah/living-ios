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
    
    var payload:[Payload] = [Payload]()
    
    
    
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
    

    
    func save(token:String,hub:Int,completion: (IsError:Bool,result: String) -> Void){
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
            "name":self.name,
            "payload":payload_array,
            "timed":self.timed
            
        ]
        
        let array = JSON(json_parameters)
        
        
        
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
                    let response_string = json["ERROR"].dictionary?.first
                    let final_string = response_string!.1[0].stringValue
                    
                    completion(IsError:true,result:final_string)
                    
                    
                    
                }
                
                
        }

    }
    
    func update(token:String,hub:Int,completion: (IsError:Bool,result: String) -> Void){
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
            "name":self.name,
            "payload":payload_array,
            "timed":self.timed
            
        ]
        
        let array = JSON(json_parameters)
        
        
        
        Alamofire.request(.PUT,endpoint,headers: headers, parameters:[:], encoding:.Custom({convertible, params in
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
                    let response_string = json["ERROR"].dictionary?.first
                    let final_string = response_string!.1[0].stringValue
                    
                    completion(IsError:true,result:final_string)
                    
                    
                    
                }
                
                
        }
        
    }
    
    
    func run(token:String,hub:Int,completion: (IsError:Bool,result: String) -> Void){
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub, self.sid)
        var payload_array: [[String: AnyObject]] = [[String: AnyObject]]()
        for command:Payload in payload{
            
            if(command.target == "sonos"){
                        payload_array.append(command.getDictionary())
            }else{
                        payload_array.append(command.getDictionary())
            }
            

        }
        

        
        let array = JSON(payload_array)
        
        
        
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
                    let response_string = json["ERROR"]
                    let final_string = response_string.stringValue
                    
                    completion(IsError:true,result:final_string)
                    
                    
                    
                }
                
                
        }
        
    }
    
    func delete(token:String,hub:Int,completion: (IsError:Bool,result: String) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Mode),hub,self.sid)
        
        Alamofire.request(.DELETE,endpoint,encoding: .JSON,headers: headers)
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