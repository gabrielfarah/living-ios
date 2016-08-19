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
    
    func load(token:String,completion: (IsError:Bool,result: String) -> Void){
            
            
            let headers = [
                "Authorization": "JWT "+token,
                "Accept": "application/json"
            ]
            
            Alamofire.request(.GET,ArSmartApi.sharedApi.ApiUrl(Api.Hubs.GetHubs),encoding: .JSON,headers: headers)
                .validate()
                .responseJSON { response  in
                    switch response.result {
                        
                    case .Success:
                        
                        self.hubs.removeAll()
                        if response.result.value != nil {
                            
                            let data = NSData(data: response.data!)
                            let json = JSON(data: data)
                            
                            //(id:String,serial:String,mac:String,isRegistered:Bool,name:String,latitude:Double,longitude:Double,radius:Double)

                            //If json is .Dictionary
                            for (_,subJson):(String, JSON) in json {
                                //Do something you want

                                
                                
                                let hid = subJson.object["id"] as! NSNumber
                                let serial = subJson.object["serial"] as! String
                                let mac = subJson.object["mac"] as! String
                                let isRegistered = subJson.object["is_registered"] as! Bool
                                var name = subJson.object["custom_name"] as! String
                                let latitude = subJson.object["latitude"] as! Double
                                let longitude = subJson.object["longitude"] as! Double
                                let radius = subJson.object["radius"] as! Double
                                
                                
                                if(name == ""){
                                    name = "[No Name]"
                                
                                }
                              

                                let new_hub = Hub(hid:hid.integerValue,serial:serial,mac:mac,isRegistered:isRegistered,name:name,latitude:latitude,longitude:longitude,radius:radius)
                                
                                
                                
                                //TODO: Ingresar todos los endpoints

                                for item in subJson["endpoints"].arrayValue {
                                    
                                    let e_name = item.object["name"] as! String
                                    
                                    
                                    let active = item.object["active"] as! Int
  
                                    
                                    let cat_id = item["category"].object["id"] as! Int
                                    let cat_desc = item["category"].object["description"] as! String
                                    let cat_code = item["category"].object["code"] as! Int
                                    
                                    let category = CategoryEndpoint(id: cat_id,description: cat_desc,code: cat_code)
                                    
                                    
                                    
                                    let created_at  = ArSmartUtils.ParseDate(item.object["created_at"] as! String)
                                    let endpoint_type = Endpoint.ConvertType(item.object["endpoint_type"] as! String)
                                    let favorite = item.object["favorite"] as! Int
                                    let id = item.object["id"] as! Int
                                    let image = item.object["image"] as! String
                                    let ip_address = item.object["ip_address"] as? String
                                    let lib_type = item.object["lib_type"] as? String
                                    let manufacturer_name = item.object["manufacturer_name"] as! String
                                    let name = item.object["name"] as! String
                                    let node = item.object["node"] as? Int
                                    let pid = item.object["pid"] as? String
                                    let port = item.object["port"] as? String
                                    let proto_ver = item.object["proto_ver"] as? String
                                    //TODO: inicializar
                                    let room:Room = Room()
                                    let sensor = item.object["sensor"] as! Int
                                    let sleep_cap = item.object["sleep_cap"] as! Bool
                                    let state = item.object["state"] as! Int
                                    let ui_class_command = item.object["ui_class_command"] as! String
                                    let uid = item.object["uid"] as! String
                                    let updated_at = ArSmartUtils.ParseDate(item.object["updated_at"] as! String)
                                    let version = item.object["version"] as? String
                                    let wkup_intv = item.object["wkup_intv"] as? String
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

                            
                            completion(IsError:false,result: "")
                            
                        }else{
                            completion(IsError:true,result:"")
                        }

                        
                        
                    case .Failure:
                        let data = NSData(data: response.data!)
                        var json = JSON(data: data)
                        let response_string = (json["ERROR"]).rawString()
                        completion(IsError:true,result: response_string!)
                        
                        
                        
                    }
                    
                    
            }
            
        }


}