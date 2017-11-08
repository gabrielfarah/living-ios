//
//  Rooms.swift
//  Living
//
//  Created by Nelson FB on 4/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftyUserDefaults
import Alamofire


class Rooms{

    var rooms = [Room]()
    
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
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Rooms), hub)
        
        Alamofire.request(endpoint, method: .get,encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    self.rooms.removeAll()
                    
                    let data = NSData(data: response.data!) as Data
                    let json = try! JSON(data: data)
                    
                    
                    //If json is .Dictionary
                    for (_,subJson):(String, JSON) in json {
                        //Do something you want
                        
                        
                        
                        let description = subJson["description"].stringValue
                        let rid = subJson["id"].intValue
                        let color = subJson["color"].stringValue
                        let image = subJson["image"].stringValue
                        let new_room = Room(room:description,rid: rid)
                        new_room.color = color
                        new_room.image = image
                        
                        self.rooms.append(new_room)
                    }
                    self.rooms = self.rooms.sorted(by: {$0.order < $1.order})
                    completion( false, "")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                    
                }
                
                
        }
        
    }

    

    func setSort(){
        if rooms.count > 0{
            for i in 0...(rooms.count - 1){
                let e = rooms[i]
                e.order = i
            }
        }

        
        
        
    }
    
    func saveSort(_ hub:Int,token:String, completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.RoomsPatch), hub)
        
        var ids = [Int]()
        var orden = [Int]()
        
        for i in 0...(rooms.count - 1){
            ids.append(rooms[i].rid)
            orden.append(i)
        }
        
        
        let joiner = ","
        let elements1 = ids
        let elements2 = orden
        let joinedStrings1 = elements1.map({ String(describing: $0) }).joined(separator: joiner)
        let joinedStrings2 = elements2.map({ String(describing: $0) }).joined(separator: joiner)
        
        
        let  parameters: [String: String] = [:]
        let json_parameters: [String: String]  = [
            "ids":joinedStrings1 as String,
            "orden":joinedStrings2 as String,
            
            
            ]
        
        
        
        Alamofire.request(endpoint,method:.post, parameters:json_parameters, encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        let json = try! JSON(value)
                        
                        
                        let url = json["url"].stringValue
                        completion(false,url)
                        
                        
                    }else{
                        completion(true,"")
                    }
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = try! JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                    
                }
                
                
        }
        
        
        
    }
    

}
