//
//  ArSmartApi.swift
//  Living
//
//  Created by Nelson FB on 21/06/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults

private let sharedApi = ArSmartApi()
class ArSmartApi{

    
    var host:String!
    var token:TokenManager?;
    var hub:Hub?
    var hubs:Hubs
    var user:User
    
    var device_manager = DeviceManager()
    
    
    static let sharedApi = ArSmartApi()
    private init(){
        self.host = "http://living.ar-smart.co"
       
        self.hub = Hub()
        
        self.user = User()
        self.token = TokenManager()
        self.hubs = Hubs()
        self.token?.endpoint = ApiUrl(Api.Auth.ApiTokenAuth)
        self.loadHub()
        
    }
    
    func loadHub(){
        let dict = Defaults["hub"].dictionary ?? nil
        print (dict)
        if dict != nil {
            self.hub?.fromDict(dict!)
        }
        
        
    }
    func setHub(hub:Hub){
    
        self.hub = hub
        //TODO: Save Hub in preferences
        Defaults["hub"] = self.hub?.toDict()
    
    }
    func getHub()->Hub{
        
        return (self.hub ?? nil)!
        
        
    }
    
    
    func getToken()->String{
        return (self.token?.GetToken())!;
    
    }
    

    
    func Logout(){
        self.token!.Logout()
    }
    func isLoggedIn()->Bool{
        if self.getToken() == "" {
            return false
        }else{
            return true
        }
    }

    
    func RegisterUser(email:String, name:String, password:String, completion: (IsError:Bool,result: String) -> Void){
        let parameters: [String: AnyObject] = [
            "email" : email,
            "password" : password,
            "mobile_os":"ios",
            "first_name":name,
            ]
        
        Alamofire.request(.POST,self.ApiUrl(Api.UserManagement.CreateUser),parameters:parameters,encoding: .JSON)
        .validate()
        .responseJSON { response  in
            switch response.result {
                
                case .Success:
                    
                    print(response.response)
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
                    completion(IsError:false,result: "")
                case .Failure:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]["email"][0]).rawString()
                    completion(IsError:true,result: response_string!)

                    print("Error")
        
            }
            
            
        }
        
    }
    func PrintTest(){
        print("TEST")
    }
    func ApiUrl(method:String)->String{
        return host + method
    }
    
    

    


}


struct Api {
    struct Auth{
        static let ApiTokenAuth = "/v1/api-token-auth/"
    }
    struct UserManagement{
        static let CreateUser = "/v1/users/"
        static let Modify = "/v1/users/%@/"
        static let Get = "/v1/users/%@/"
        static let Delete = "/v1/users/%@/"
        static let GetProfile = "/v1/profile/%@/"
        static let Guests = "/v1/hubs/%@/guests/"
        static let NewGuest = "/v1/hubs/%@/guests/"
        static let ModifyGuest = "/v1/hubs/%@/guests/%@/"
        static let DeleteGuest = "/v1/hubs/%d/guests/%d/"
        static let GetGuest = "/v1/hubs/%@/guests/%@/"
        static let ResetPassword = "/v1/reset_password/%@/"
        static let ChangePassword = "/v1/reset_password/"
        static let ChangePassword1 = "/v1/change_password/"
        
        
    }
    struct Hubs{
        static let CreateHub = "/v1/hubs/"
        static let GetHubs = "/v1/hubs/"
        static let Invite = "/v1/hubs/%d/guests/"
        static let Actions = "/v1/hubs/%d/actions/"
        static let Rooms = "/v1/hubs/%d/rooms/"
        static let Room = "/v1/hubs/%d/rooms/%d/"
        static let AddWifi = "/v1/hubs/%d/command/add/wifi/"
        static let AddZWave = "/v1/hubs/%d/command/add/zwave/"

        static let RemoveZWave = "/v1/hubs/%d/command/remove/zwave/"
        static let Commands = "/v1/hubs/%d/command/"
        static let CommandsGet = "/v1/hubs/%d/command/get/"
        static let CommandsSet = "/v1/hubs/%d/command/set/"
        static let Endpoints = "/v1/hubs/%d/endpoints/"
        static let Endpoint = "/v1/hubs/%d/endpoints/%d/"
        static let Modes = "/v1/hubs/%d/modes/"
        static let Mode = "/v1/hubs/%d/modes/%d/"
        static let Triggers = "/v1/hubs/%d/endpoints/%d/triggers/"
    }

    
    
}
extension ArSmartApi {

    static let hub = DefaultsKey<AnyObject>("hub")
}


