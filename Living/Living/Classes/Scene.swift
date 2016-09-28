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
            "payload":payload_array as AnyObject,
            "timed":self.timed as AnyObject
            
        ]
        
        let array = JSON(json_parameters)
        
        
        
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
            "payload":payload_array as AnyObject,
            "timed":self.timed as AnyObject
            
        ]
        
        let array = JSON(json_parameters)
        
        
        
        Alamofire.request(endpoint, method:.put, parameters:json_parameters, encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    
                    completion(false, "")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = json["ERROR"].dictionary?.first
                    let final_string = response_string!.1[0].stringValue
                    
                    completion(true,final_string)
                    
                    
                    
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
                        payload_array.append(command.getDictionary())
            }else{
                        payload_array.append(command.getDictionary())
            }
            

        }
        

        
        let array = JSON(payload_array)
        
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
                    let response_string = (json["ERROR"]).rawString()
                    completion(true, response_string!)
                    
                    
                    
                }
                
                
        }
        
    }
    

}
