//
//  Location.swift
//  Living
//
//  Created by Nelson FB on 4/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults

class Hub{

    var hid:Int
    var serial:String
    var mac:String
    var isRegistered:Bool
    var name:String
    var latitude:Double
    var longitude:Double
    var radius:Double
    
    var endpoints:Endpoints
    
    init(){
        self.hid = 0
        self.serial = ""
        self.mac = ""
        self.isRegistered = false
        self.name = ""
        self.latitude = 0.0
        self.longitude = 0.0
        self.radius = 100.0
        self.endpoints = Endpoints()
    }
    
    init(hid:Int,serial:String,mac:String,isRegistered:Bool,name:String,latitude:Double,longitude:Double,radius:Double){
        self.hid = hid
        self.serial = serial
        self.mac = mac
        self.isRegistered = isRegistered
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.endpoints = Endpoints()
        
    }
    
    func Created(completion: (result: String) -> Void){
    
        let parameters: [String: AnyObject] = [
            "serial" : serial,
            "mac" : mac,
            "isRegistered":"ios",
            "name":name,
            "latitude":latitude,
            "longitude":longitude,
            "radius":radius,
            ]
        
        let token =  ArSmartApi.sharedApi.getToken()
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        Alamofire.request(.POST,ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CreateHub),parameters:parameters,encoding: .JSON,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .Success:
                    
                    print(response.response)
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
                    completion(result: "Ok")
                case .Failure:
                    completion(result: "Not Ok")
                    print("Error")
                    
                }
                
                
        }

    }
    
}
