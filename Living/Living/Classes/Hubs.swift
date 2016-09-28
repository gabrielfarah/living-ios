//
//  Hubs.swift
//  Living
//
//  Created by Nelson FB on 4/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Hubs{

    var hubs = [Hub]()
    
    init(){
    
    }

    
    func load(_ token:String,completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
            
            
            let headers = [
                "Authorization": "JWT "+token,
                "Accept": "application/json"
            ]
            
        Alamofire.request(ArSmartApi.sharedApi.ApiUrl(Api.Hubs.GetHubs), method:.get,encoding:  JSONEncoding.default,headers: headers)
                .validate()
                .responseJSON { response  in
                    switch response.result {
                        
                    case .success:
                        
                        self.hubs.removeAll()
                        if response.result.value != nil {
                            
                            let data = NSData(data: response.data!) as Data
                            let json = JSON(data: data)
                            
                            //(id:String,serial:String,mac:String,isRegistered:Bool,name:String,latitude:Double,longitude:Double,radius:Double)

                            //If json is .Dictionary
                            for (_,subJson):(String, JSON) in json {
                                //Do something you want

                                
                                
                                let hid = subJson["id"].intValue
                                let serial = subJson["serial"].stringValue
                                let mac = subJson["mac"].stringValue
                                let isRegistered = subJson["is_registered"].boolValue
                                var name = subJson["custom_name"].stringValue
                                let latitude = subJson["latitude"].doubleValue
                                let longitude = subJson["longitude"].doubleValue
                                let radius = subJson["radius"].doubleValue
                                
                                
                                if(name == ""){
                                    name = "[No Name]"
                                
                                }
                              

                                let new_hub = Hub(hid:hid,serial:serial,mac:mac,isRegistered:isRegistered,name:name,latitude:latitude,longitude:longitude,radius:radius)
                                
                                
                                
                                //TODO: Ingresar todos los endpoints

                                for item in subJson["endpoints"].arrayValue {
                                    
                                    let e_name = item["name"].stringValue
                                    
                                    
                                    let active = item["active"].intValue
  
                                    
                                    let cat_id = item["category"]["id"].intValue
                                    let cat_desc = item["category"]["description"].stringValue
                                    let cat_code = item["category"]["code"].intValue
                                    
                                    let category = CategoryEndpoint(id: cat_id,description: cat_desc,code: cat_code)
                                    
                                    
                                    
                                    let created_at  = ArSmartUtils.ParseDate(item["created_at"].stringValue)
                                    let endpoint_type = Endpoint.ConvertType(item["endpoint_type"].stringValue)
                                    let favorite = item["favorite"].intValue
                                    let id = item["id"].intValue
                                    let image = item["image"].stringValue
                                    let ip_address = item["ip_address"].stringValue
                                    let lib_type = item["lib_type"].stringValue
                                    let manufacturer_name = item["manufacturer_name"].stringValue
                                    let name = item["name"].stringValue
                                    let node = item["node"].intValue
                                    let pid = item["pid"].stringValue
                                    let port = item["port"].stringValue
                                    let proto_ver = item["proto_ver"].stringValue
                                    //TODO: inicializar
                                    let room:Room = Room()
                                    let sensor = item["sensor"].intValue
                                    let sleep_cap = item["sleep_cap"].boolValue
                                    let state = item["state"].intValue
                                    let ui_class_command = item["ui_class_command"].stringValue
                                    let uid = item["uid"].stringValue
                                    let updated_at = ArSmartUtils.ParseDate(item["updated_at"].stringValue)
                                    let version = item["version"].stringValue
                                    let wkup_intv = item["wkup_intv"].stringValue
                                    if(ui_class_command == "ui-sonos"){
                                        let endpoint = Sonos(active: active, category: category, created_at: created_at, endpoint_type: endpoint_type, favorite: favorite, id: id, image: image, ip_address: ip_address, lib_type: lib_type, manufacturer_name: manufacturer_name, name: name, node: node, pid: pid, port: port, proto_ver: proto_ver, room: room, sensor: sensor, sleep_cap: sleep_cap, state: state, ui_class_command: ui_class_command, uid: uid, updated_at: updated_at, version: version, wkup_intv: wkup_intv)
                                        new_hub.endpoints.add(endpoint)
                                    
                                    }else{
                                    
                                        let endpoint = Endpoint(active: active, category: category, created_at: created_at, endpoint_type: endpoint_type, favorite: favorite, id: id, image: image, ip_address: ip_address, lib_type: lib_type, manufacturer_name: manufacturer_name, name: name, node: node, pid: pid, port: port, proto_ver: proto_ver, room: room, sensor: sensor, sleep_cap: sleep_cap, state: state, ui_class_command: ui_class_command, uid: uid, updated_at: updated_at, version: version, wkup_intv: wkup_intv)
                                        new_hub.endpoints.add(endpoint)
                                        
                                    }

                                    
                                    
                       
                                    
                                }

                                self.hubs.append(new_hub)
                            }

                            
                            completion(false, "")
                            
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
