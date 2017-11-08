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
    
    func save(_ token:String,hub:Int, completion:  @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        let parameters: [String: AnyObject] = [
            "email" : self.email as AnyObject
            ]

        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        

        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Invite), hub)

        
        
        Alamofire.request(endpoint, method: .post, parameters:parameters,encoding: URLEncoding.httpBody,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
            
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        
                    }
                    completion( false,"")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                

                    
                }
                
                
        }
        
    }

    
    func delete(_ token:String,hub:Int,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.UserManagement.DeleteGuest),hub,self.uid)
        
        Alamofire.request(endpoint,method: .delete, encoding:JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    
                    completion(false,"")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                    
                }
                
                
        }
        
    }
    
    

    
    

}
