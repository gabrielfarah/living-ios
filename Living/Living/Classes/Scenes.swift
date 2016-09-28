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
                    for (index,subJson):(String, JSON) in json {
                        //Do something you want
                        
                        let name = subJson["name"].stringValue
                        let sid = subJson["id"].intValue
                        
                        var scene = Scene(name: name,id: sid)
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
                        

                        
                        //let new_room = Room(room:description,rid: rid)
                        
                        //self.scenes.append(new_room)
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
