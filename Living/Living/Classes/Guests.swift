//
//  Guests.swift
//  Living
//
//  Created by Nelson FB on 17/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Guests{

    var guests = [Guest]()


    
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
        
         let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Invite), hub)
        
        Alamofire.request(endpoint, method: .get,encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    do {
                        self.guests.removeAll()
                        let data = NSData(data: response.data!) as Data
                        let json = try! JSON(data: data)
                        
                        
                        //If json is .Dictionary
                        for (_,subJson):(String, JSON) in json {
                            //Do something you want
                            
                            
                            
                            let uid = subJson["id"].number
                            let email = subJson["email"].stringValue

                            
                            let new_user = Guest(uid:uid!.intValue , email:email)
                            
                            self.guests.append(new_user)
                        }

                        completion(false,"")
                    }catch{
                         completion(false,"")
                        
                    }
                    
                case .failure:
                    do {
                        let data = NSData(data: response.data!) as Data
                        var json = try! JSON(data: data)
                        let response_string = (json["ERROR"]).rawString()
                        completion(true,response_string!)
                    }catch{
                        completion(false,"")
                        
                    }
                    
                    
                    
                }
                
                
        }
        
    }
    
}
