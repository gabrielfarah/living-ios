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
                    self.guests.removeAll()
                    let data = NSData(data: response.data!) as Data
                    let json = JSON(data: data)
                    
                    
                    //If json is .Dictionary
                    for (_,subJson):(String, JSON) in json {
                        //Do something you want
                        
                        
                        
                        let uid = subJson["id"].number
                        let email = subJson["email"].stringValue

                        
                        let new_user = Guest(uid:uid!.intValue , email:email)
                        
                        self.guests.append(new_user)
                    }

                    completion(false,"")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                    
                }
                
                
        }
        
    }
    
}
