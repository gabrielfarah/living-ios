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


class Scenes{
    
    var scenes = [Scene]()
    
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
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Modes), hub)
        
        Alamofire.request(endpoint, method:.get, encoding: JSONEncoding.default,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    self.scenes.removeAll()
                    
                    let data = NSData(data: response.data!) as Data
                    let json = JSON(data: data)
                    
                    

                    
                    //If json is .Dictionary
                    for (_,subJson):(String, JSON) in json {
                        //Do something you want
                        
                        let name = subJson["name"].stringValue
                        let sid = subJson["id"].intValue
                        let order = subJson["orden"].intValue
                        
                        
                        let scene = Scene(name: name,id: sid)
                        scene.order = order
                        for item in subJson["payload"].arrayValue {
                        

                            let type =  item["type"].stringValue
                            let node =  item["node"].intValue
                            let value =  item["v"].intValue
                            let endpoint_id =  item["endpoint_id"].intValue
                            let ip =  item["ip"].stringValue
                            let function_name =  item["function"].stringValue
                            let target =  item["target"].stringValue
                          

                            
                            let payload = Payload(type: type,node:node,value:value,target:target,endpoint_id:endpoint_id,ip:ip,function_name:function_name,parameters:[])
                            
                            scene.payload.append(payload)
                        }
                        

                        self.scenes.append(scene)
                        // Aqui se ordenan por orden alfabetico
                        self.scenes = self.scenes.sorted(by: {$0.name < $1.name})

                        
                        //let new_room = Room(room:description,rid: rid)
                        
                        //self.scenes.append(new_room)
                    }
                    self.setSort()
                    completion(false,"")
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                    
                }
                
                
        }
        
    }
    
    func setSort(){
        if scenes.count>0{
            for i in 0...(scenes.count - 1){
                let e = scenes[i]
                e.order = i
            }
        }

        
        
        
    }
    
    func saveSort(_ hub:Int,token:String, completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.ModesPatch), hub)
        
        var ids = [Int]()
        var orden = [Int]()
        
        for i in 0...(scenes.count - 1){
            ids.append(scenes[i].sid)
            orden.append(scenes[i].order)
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
                        let json = JSON(value)
                        
                        
                        let url = json["url"].stringValue
                        completion(false,url)
                        
                        
                    }else{
                        completion(true,"")
                    }
                    
                    
                case .failure:
                    let data = NSData(data: response.data!) as Data
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(true,response_string!)
                    
                    
                    
                }
                
                
        }
        
        
        
    }

    
    
}
