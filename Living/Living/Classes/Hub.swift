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
    
    
    var project_info_id:Int
    var project_info_name:String
    var project_info_color:String

    
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
        
        
        self.project_info_id = 0
        self.project_info_name = ""
        self.project_info_color = "#2CC2BE"
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
        
        self.project_info_id = 0
        self.project_info_name = ""
        self.project_info_color = "#2CC2BE"

    }
    init(hid:Int,serial:String,mac:String,isRegistered:Bool,name:String,latitude:Double,longitude:Double,radius:Double, project_info_id:Int, project_info_name:String,project_info_color:String){
        self.hid = hid
        self.serial = serial
        self.mac = mac
        self.isRegistered = isRegistered
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.endpoints = Endpoints()
        
        self.project_info_id = project_info_id
        self.project_info_name = project_info_name
        self.project_info_color = project_info_color
        
    }
    
    func Created(_ completion: @escaping (_ result: String) -> Void){
    
        let parameters: [String: AnyObject] = [
            "serial" : serial as AnyObject,
            "mac" : mac as AnyObject,
            "isRegistered":"ios" as AnyObject,
            "name":name as AnyObject,
            "latitude":latitude as AnyObject,
            "longitude":longitude as AnyObject,
            "radius":radius as AnyObject,
            ]
        
        let token =  ArSmartApi.sharedApi.getToken()
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        Alamofire.request(ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CreateHub),method:.post,parameters:parameters,encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    print(response.response)
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
                    completion("Ok")
                case .failure:
                    completion("Not Ok")
                    print("Error")
                    
                }
                
                
        }

    }
    
    func getFavorites()->[Endpoint]{
        
        var favorites = [Endpoint]()
        
        for endpoint:Endpoint in self.endpoints.endpoints {
            if(endpoint.favorite == 1){
            favorites.append(endpoint)
            
            }
        
        }
        
        return favorites
    }
    
    func toDict()->[String:AnyObject] {

        

        
        let dict_hub:[String:AnyObject] = [
            "hid" : self.hid as AnyObject,
            "serial" : self.serial as AnyObject,
            "mac" : self.serial as AnyObject,
            "isRegistered" : self.isRegistered as AnyObject,
            "name" : self.name as AnyObject,
            "latitude" : self.latitude as AnyObject,
            "longitude" : self.longitude as AnyObject,
            "radius" : self.radius as AnyObject,
            "project_info_id" : self.project_info_id as AnyObject,
            "project_info_name" : self.project_info_name as AnyObject,
            "project_info_color" : self.project_info_color as AnyObject,

        ]
        return dict_hub
    
    
    
    }
    
    func fromDict(_ dict_hub:NSDictionary) {
        
        
        
        self.hid = dict_hub["hid"] as! Int
        self.serial = dict_hub["serial"] as! String
        self.mac = dict_hub["mac"] as! String
        self.isRegistered = dict_hub["isRegistered"] as! Bool
        self.name = dict_hub["name"] as! String
        self.latitude = dict_hub["latitude"] as! Double
        self.longitude = dict_hub["longitude"] as! Double
        self.radius = dict_hub["radius"] as! Double
        
        self.project_info_id = dict_hub["project_info_id"] as! Int
        self.project_info_name = dict_hub["project_info_name"] as! String
        self.project_info_color = dict_hub["project_info_color"] as! String
        
        
        
    }
    
    func saveOrder(){
    
        //TODO: Obtener orden del endpoint
    
    }
    
    
}
