//
//  TokenManager.swift
//  Living
//
//  Created by Nelson FB on 5/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults
import JWTDecode

class TokenManager{
    
    var token:String;
    var expire:NSDate;
    var endpoint:String;
    var user:String;
    var password:String;
    
    init(){
    
        self.token = Defaults["token"].string ?? ""
        self.expire = NSDate()
        self.endpoint = ""
        self.user = Defaults["user"].string ?? ""
        self.password = Defaults["password"].string ?? ""
    }
    
    
    func Expire()->NSDate{
    
        return self.expire
    
    }
    func hasExpired()->Bool{
    
        return false;
    }
    func GetToken()->String{
    
        return self.token;
    }
    func Logout(){
        self.token="";
        Defaults.removeAll()
    }
    
    
    func CheckTokenTest(){
    CheckToken("caev03@gmail.com", password: "caev03") { (result) in
        
        do {
            let jwt = try decode(self.token)
            let json = JSON(jwt.body)
            print(json)
            let exp = json["exp"].stringValue
            let date = NSDate(timeIntervalSince1970: Double(exp)!)
            print(date)
            
        } catch {
            print("Failed to decode JWT: \(error)")
        }
    }
    
    
    }
    
    func CheckTokenAuto(){
        CheckToken(self.user, password: self.password) { (result) in
            
            do {
                let jwt = try decode(self.token)
                let json = JSON(jwt.body)
                print(json)
                let exp = json["exp"].stringValue
                let date = NSDate(timeIntervalSince1970: Double(exp)!)
                print(date)
                
            } catch {
                print("Failed to decode JWT: \(error)")
            }
        }
        
        
    }
    
    func CheckToken(email:String, password:String, completion: (isError:Bool,result: String) -> Void){
        if (self.token == ""){
            self.GetApiToken(email,password:password ){
                (isError:Bool,result:String)in
                completion(isError:isError,result: result)
            }
        }else{
            completion(isError:false, result: "")
            print("Stored Token:", self.token)
        }
        
    }
    private func GetApiToken(email:String, password:String,completion: (isError:Bool,result: String) -> Void){
        
        
        
        let parameters: [String: AnyObject] = [
            "email" : email,
            "password" : password,
            ]
        
        
        
        
        
        Alamofire.request(.POST,self.endpoint,parameters:parameters,encoding: .JSON)
            .validate()
            .responseJSON { response in
                switch response.result {
                    
                case .Success:
                    
                    let token_result = response.result.value as? NSDictionary
                    self.token = (token_result!["token"] as? String)!
                    Defaults["token"] = self.token
                    
                    Defaults["user"] = email
                    Defaults["password"] = password
                    
                    self.user = email
                    self.password = password
                    print("[GetApiToken]Token: \(self.token)")
                    completion(isError: false,result: "Ok")
                    
                    
                    
                    
                    
                case .Failure(let error):
                    
                    let data = NSData(data: response.data!)
                    let final_response = JSON(data: data)
                    let response_string = (final_response["non_field_errors"][0]).rawString()
                    print("Error Api Auth")
                    
                    if(response_string != "null"){
                        completion(isError:true, result: response_string!)
                    }else{
                        completion(isError:true, result: error.localizedDescription)
                    }
                    
                    
                }
                
                
                
        }
        
    }


}
extension TokenManager {
    static let token = DefaultsKey<String?>("token")
    static let launchCount = DefaultsKey<Int>("launchCount")
    static let user = DefaultsKey<String?>("user")
    static let password = DefaultsKey<Int>("password")
}


