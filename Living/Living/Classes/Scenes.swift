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
    
    
    func load(token:String,hub:Int,completion: (IsError:Bool,result: String) -> Void){
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.Modes), hub)
        
        Alamofire.request(.GET,endpoint,encoding: .JSON,headers: headers)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .Success:
                    
                    self.scenes.removeAll()
                    
                    let data = NSData(data: response.data!)
                    let json = JSON(data: data)
                    
                    

                    
                    //If json is .Dictionary
                    for (index,subJson):(String, JSON) in json {
                        //Do something you want
                        
                        let name = subJson.object["name"] as! String
                        let sid = subJson.object["id"] as! Int
                        
                        var scene = Scene(name: name,id: sid)
                        for item in subJson["payload"].arrayValue {
                        

                            let type =  item.object["type"] as! String
                            let node =  item.object["node"] as! Int
                            let value =  item.object["v"] as! Int
                            let endpoint_id =  item.object["endpoint_id"] as! Int
                            let ip =  item.object["ip"] as! String
                            let function_name =  item.object["function"] as! String
                            let target =  item.object["target"] as! String
                            

                            
                            let payload = Payload(type: type,node:node,value:value,target:target,endpoint_id:endpoint_id,ip:ip,function_name:function_name,parameters:[])
                            scene.payload.append(payload)
                        }
                        

                        self.scenes.append(scene)
                        

                        
                        //let new_room = Room(room:description,rid: rid)
                        
                        //self.scenes.append(new_room)
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