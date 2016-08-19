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


    func load(token:String,hub:Int,completion: (IsError:Bool,result: String) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
         let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Invite), hub)
        
        Alamofire.request(.GET,endpoint,encoding: .JSON,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .Success:
                    self.guests.removeAll()
                    let data = NSData(data: response.data!)
                    let json = JSON(data: data)
                    
                    
                    //If json is .Dictionary
                    for (_,subJson):(String, JSON) in json {
                        //Do something you want
                        
                        
                        
                        let uid = subJson.object["id"] as! NSNumber
                        let email = subJson.object["email"] as! String

                        
                        let new_user = Guest(uid:uid.integerValue,email:email)
                        
                        self.guests.append(new_user)
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