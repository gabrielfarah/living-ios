//
//  Guest.swift
//  Living
//
//  Created by Nelson FB on 17/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Guest{

    var uid:Int;
    var email:String;
    
    
    init(){
        self.uid = 0
        self.email = ""
    }
    init(uid:Int, email:String){
        self.uid = uid
        self.email = email
    }
    init(email:String){
        self.uid = 0
        self.email = email
    }
    
    func save(token:String,hub:Int, completion:  (IsError:Bool,result: String) -> Void){
        
        let parameters: [String: AnyObject] = [
            "email" : self.email
            ]

        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        

        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Invite), hub)

        
        
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

    
    func delete(token:String,hub:Int,completion: (IsError:Bool,result: String) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.UserManagement.DeleteGuest),hub,self.uid)
        
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