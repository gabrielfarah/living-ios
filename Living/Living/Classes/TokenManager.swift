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
    var expire:Date;
    var endpoint:String;
    var user:String;
    var password:String;
    var exp_date:Date;
    
    init(){
    
        self.token = Defaults["token"].string ?? ""
        self.expire = Date()
        self.endpoint = ""
        self.user = Defaults["user"].string ?? ""
        self.password = Defaults["password"].string ?? ""
        
        self.exp_date = Defaults["exp_date"].date ?? Date()

        
    }
    
    
    func Expire()->Date{
    
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
        CheckToken("caev03@gmail.com", password: "caev03") {
            (isError:Bool, result:String) in
        
        do {
            let jwt = try decode(jwt: self.token)
            let json = JSON(jwt.body)
            print(json)
            let exp = json["exp"].stringValue
            let date = Date(timeIntervalSince1970: Double(exp)!)
            self.exp_date = date
            print(date)
            
        } catch {
            print("Failed to decode JWT: \(error)")
        }
    }
    
    
    }
    
    func CheckTokenAuto(){
        CheckToken(self.user, password: self.password) {
            
            (isError:Bool, result:String) in
            
            do {
                let jwt = try decode(jwt: self.token)
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
    
    func CheckToken(_ email:String, password:String, completion: @escaping (_ isError:Bool,_ result: String) -> Void){
        if (self.token == ""){
            self.GetApiToken(email,password:password ){
                (isError:Bool,result:String)in
                
                
                completion(isError,result)
            }
        }else{
            
    
            
            if exp_date < Date(){
                self.GetApiToken(email,password:password ){
                    (isError:Bool,result:String)in
                    
                    
                    completion(isError,result)
                }
            
            }else{
            
                completion(false, "")
            }
            
            
            
            print("Stored Token:", self.token)
        }
        
    }
    
    
    func refresh_token(_ email:String, password:String,completion: @escaping (_ isError:Bool,_ result: String) -> Void){

    
        let parameters: [String: AnyObject] = [
            "email" : email as AnyObject,
            "password" : password as AnyObject,
            ]
        
        
        
        Alamofire.request(self.endpoint,method:.post,parameters:parameters,encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                    
                case .success:
                    
                    let token_result = response.result.value as? NSDictionary
                    self.token = (token_result!["token"] as? String)!
                    Defaults["token"] = self.token
                    
                    Defaults["user"] = email
                    Defaults["password"] = password
                    
                    self.user = email
                    self.password = password
                    print("[GetApiToken]Token: \(self.token)")
                    completion(false,"Ok")
                    
                    
                    
                    
                    
                case .failure(let error):
                    
                    let data = NSData(data: response.data!) as Data
                    do{
                    let final_response = try! JSON(data: data)
                    let response_string = (final_response["non_field_errors"][0]).rawString()
                    print("Error Api Auth")
                    
                    if(response_string != "null"){
                        completion(true,  response_string!)
                    }else{
                        completion(true, error.localizedDescription)
                    }
                    }catch{
                        
                        completion(false, "")
                    }
                    
                    
                }
                
                
                
        }
    
    }
    
    fileprivate func GetApiToken(_ email:String, password:String,completion: @escaping (_ isError:Bool,_ result: String) -> Void){
        
        
        
        let parameters: [String: AnyObject] = [
            "email" : email as AnyObject,
            "password" : password as AnyObject,
            ]
        
        
        
        
        
        Alamofire.request(self.endpoint,method:.post,parameters:parameters,encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                    
                case .success:
                    
                    let token_result = response.result.value as? NSDictionary
                    self.token = (token_result!["token"] as? String)!
 
                    
                    do {
                        let jwt = try decode(jwt: self.token)
                        let json = JSON(jwt.body)
                        print(json)
                        let exp = json["exp"].stringValue
                        let date = Date(timeIntervalSince1970: Double(exp)!)
                        self.exp_date = date
                        print(date)
                        Defaults["exp_date"] = self.exp_date
                        
                    } catch {
                        print("Failed to decode JWT: \(error)")
                    }
                    
                    Defaults["token"] = self.token
                    
                    Defaults["user"] = email
                    Defaults["password"] = password
                    
                    self.user = email
                    self.password = password
                
   
                    
                    
                    completion(false,"Ok")
                    
                    
       
                    
                    
                case .failure(let error):
                    do {
                    let data = NSData(data: response.data!) as Data
                    let final_response = try! JSON(data: data)
                    let response_string = (final_response["non_field_errors"][0]).rawString()
                    print("Error Api Auth")
                    
                    if(response_string != "null"){
                        completion(true,  response_string!)
                    }else{
                        completion(true, error.localizedDescription)
                    }
                }catch{
                    completion(false, "")
                    
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
    static let exp_date = DefaultsKey<Int>("exp_date")
}


