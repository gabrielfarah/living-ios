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
    var modeId:Int = 0
    var time:Int = 0
    var time_until:Int = 0
    var notify:Bool = false
    
    var days:[Int] = [Int]()
    
    init(){
        tid = 0
        payload = [Payload]()
        endpoint = Endpoint()
    }
    func save(_ token:String,hub:Int,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
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

            "mode_id":modeId as AnyObject,
            "notify":notify as AnyObject,
            "primary_value":[255.0,255.0] as AnyObject,
            "days_of_the_week":days as AnyObject,
            "minute_of_day":[time,time_until] as AnyObject

            
        ]

        Alamofire.request(url_endpoint, method:.post, parameters:json_parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    
                    completion(false,"El trigger fue creado con éxito")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = json["ERROR"].dictionary?.first
                    let final_string = response_string!.1[0].stringValue
                    
                    completion(true,final_string)
                    
                    
                    
                }
                
                
        }
        
    }
    func update(){}
    

}



