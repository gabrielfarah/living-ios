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
    
    
    func load(_ token:String,hub:Int,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        let _email = ArSmartApi.sharedApi.token?.user
        let _pwd = ArSmartApi.sharedApi.token?.password
        
        let expired = ArSmartApi.sharedApi.token?.exp_date
        let now = Date()
        
        if(now < expired!){
            self.load2(token,hub: hub, completion: { (IsError, result) in
                completion(IsError,result);
            })
        }else{
            ArSmartApi.sharedApi.token?.refresh_token(_email!, password: _pwd!, completion: { (IsError, result) in
                if(IsError){
                    //TODO: Que hacer si hay error
                    completion(true,"Token no valido");
                    
                }else{
                    self.load2(token,hub: hub, completion: { (IsError, result) in
                        completion(IsError,result);
                    })
                }
            })
        }
        
        
    }
    
    
    
    func load2(_ token:String,hub:Int,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Actions), hub)
        
        Alamofire.request(endpoint, method: .get,encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    let data = NSData(data: response.data!) as Data
                    let json = try! JSON(data: data)
                    
                    
                    //If json is .Dictionary
                    for (_,subJson):(String, JSON) in json {
                        //Do something you want
                    
                        let message = subJson["message"].stringValue
                        let created_at = subJson["created_at"].stringValue
                        let new_Action = Action(message:message,created_at:created_at)
                        self.actions.append(new_Action)
                    }

                    
                    completion(false, "")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                }
                
                
        }
        
    }




}
