//
//  Trigger.swift
//  Living
//
//  Created by Nelson FB on 26/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



class Trigger{

    var tid:Int
    var payload:[Payload]?
    var endpoint:Endpoint
    
    init(){
        tid = 0
        payload = [Payload]()
        endpoint = Endpoint()
    }
    func save(token:String,hub:Int,completion: (IsError:Bool,result: String) -> Void){
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let url_endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Triggers), hub,endpoint.id)
        var payload_array: [[String: AnyObject]] = [[String: AnyObject]]()

        for command:Payload in payload!{
            
            
            if(command.target == "sonos"){
                payload_array.append(command.getDictionary())
            }else{
                payload_array.append(command.getDictionary())
            }
            
            
        }
        
        
        
        let json_parameters: [String: AnyObject]  = [

            "payload":payload_array,
            "primary_value":1.0,
            "operand":"equals",
            "notify": false, // Cuando se active desea la notificacion
            
        ]
        
        let array = JSON(json_parameters)
        
        
        
        Alamofire.request(.POST,url_endpoint,headers: headers, parameters:[:], encoding:.Custom({convertible, params in
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
    func update(){}
    

}



