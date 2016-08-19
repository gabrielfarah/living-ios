//
//  Sonos.swift
//  Living
//
//  Created by Nelson FB on 10/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Sonos:Endpoint{



    func GetPlayList(){
        
        let hub:Int = (ArSmartApi.sharedApi.hub?.hid)!
        let token:String = ArSmartApi.sharedApi.getToken()
        
        super.GetLevel(hub, token: token, value: "", function: "get_sonos_playlist") { (IsError, result) in
            if(IsError){
                print("Error")
            }else{
                print("No Error")
                //TODO: Check Url
                self.GetList(token, url: result, completion: { (IsError, result) in
                    
                })
                
                
            }
        }
    
    
    
    }
    
    
    func GetList(token:String, url:String,completion: (IsError:Bool,result: String) -> Void){
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        
        Alamofire.request(.GET,ArSmartApi.sharedApi.ApiUrl(url),encoding: .JSON,headers: headers)
            .validate()
            .responseJSON {
                response  in
                switch response.result {
                    
                case .Success:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let status = (json["status"]).rawString()
                    
                    
                    

                        
                    
                        
                    if(status == "processing"){
                        print("Processing..")
                        self.GetList(token, url: url, completion: { (IsError, result) in
                            completion(IsError:IsError,result:result)
                        })
                    }else{
                        completion(IsError:false,result:"")
                    }
                        
                    
                        
                        
                        
                        
                    
                    
                    
                    
                    
                    
                    break
                    
                    
                case .Failure:
                    print("error..")
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    
                    completion(IsError:true,result:response_string!)
                    
                    
                }
                
                
        }
        
        
        
        
        
        
    }

    
    
    func Play(){}
    func Pause(){}
    func Previous(){}
    func Next(){}
    func Stop(){}
    func GetUIInfo(){}
    func SetVolume(volume:Int){}
    
    
}