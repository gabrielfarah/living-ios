//
//  Room.swift
//  Living
//
//  Created by Nelson FB on 19/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Room{
    
    
    
    var description:String
    var rid:Int
    
    
    init(){
        self.description = ""
        self.rid = 0
        
    }
    init(room:String){
        self.description = room
        self.rid = 0
    }
    init(room:String,rid:Int){
        self.description = room
        self.rid = rid
    }
    
    func save(token:String,hub:Int, completion:  (IsError:Bool,result: String) -> Void){
        
        let parameters: [String: AnyObject] = [
            "description" : self.description
        ]
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Rooms), hub)
        
        
        
        Alamofire.request(.POST,endpoint,parameters:parameters,encoding: .JSON,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .Success:
                    
                    print(response.response)
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        
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