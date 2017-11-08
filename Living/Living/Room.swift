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
    var color:String
    var order:Int
    var image:String
    init(){
        self.description = ""
        self.rid = 0
        self.color = ""
        self.order = 0
        self.image = ""
        
    }
    init(room:String){
        self.description = room
        self.rid = 0
        self.color = ""
        self.order = 0
        self.image = ""
    }
    init(room:String,rid:Int){
        self.description = room
        self.rid = rid
        self.color = ""
        self.order = 0
        self.image = ""
    }
    init(color:String,rid:Int){
        self.description = ""
        self.rid = rid
        self.color = color
        self.order = 0
        self.image = ""
    }
    
    func save(_ token:String,hub:Int, completion:  @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        let parameters: [String: AnyObject] = [
            "description" : self.description as AnyObject,
            "color" : self.color as AnyObject,
            "orden" : self.order as AnyObject,
            "image" : self.image as AnyObject
        ]
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json",
            "Accept-Language":"es-es",
        ]
        
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Rooms), hub)
        
        
        
        Alamofire.request(endpoint, method: .post, parameters:parameters,encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    print(response.response)
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        
                    }
                    completion(false,"")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                    
                }
                
                
        }
        
    }
    func update(_ token:String,hub:Int, completion:  @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        let parameters: [String: AnyObject] = [
            "description" : self.description as AnyObject,
            "color" : self.color as AnyObject,
            "orden" : self.order as AnyObject,
            "image" : self.image as AnyObject
        ]
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json",
            "Accept-Language":"es-es",
            ]
        
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Room), hub,self.rid)
        
        
        
        Alamofire.request(endpoint, method: .patch, parameters:parameters,encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    print(response.response)
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        
                    }
                    completion(false,"")
                    
                    
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
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Room), hub,self.rid)
        
        Alamofire.request(endpoint, method:.delete, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    
                    completion(false,"")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true, response_string!)
                    
                    
                    
                }
                
                
        }
        
    }
    
    func ImageNamed()->String{
        
        if self.image != ""{
            return self.image
        }else{
            return "default_icon"
        }
    }
    static func NameImages(name:String)->String{
        
        return name;
        
    }
    
}
