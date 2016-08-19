//
//  Actions.swift
//  Living
//
//  Created by Nelson FB on 19/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Actions{

    var actions = [Action]()
    
    
    func load(token:String,hub:Int,completion: (IsError:Bool,result: String) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Actions), hub)
        
        Alamofire.request(.GET,endpoint,encoding: .JSON,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .Success:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    
                    
                    //If json is .Dictionary
                    for (_,subJson):(String, JSON) in json {
                        //Do something you want
                        
                        
                        
                        let message = subJson.object["message"] as! String
                        let created_at = subJson.object["created_at"] as! String
                        
                        
                        let new_Action = Action(message:message,created_at:created_at)
                        
                        self.actions.append(new_Action)
                    }

                    
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