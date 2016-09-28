//
//  User.swift
//  Living
//
//  Created by Nelson FB on 21/06/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration
import SwiftyJSON

class User{
    
    var mName:String?;
    var mLastName:String?;
    var mEmail:String?;
    var mPushToken:String?;
    var mLatitude:String?;
    var mLongitude:String?;
    var mPassword:String?;
    
    func Create(){}
    func Update(){}
    func Get(){}
    func Invite(){}
    func Delete(){}
    func ResetPassword(){}
    func Save(){}
    
    /**
     Login
     Función que permite  conectarse a la plataforma de Living/Domu
     
     @param email Correo electrónico representado en tipo de datos String.
     @param password Contraseña
     @param completion Funcíon callback
     
     */
    
    func Login(_ email:String, password:String, completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
    
        ArSmartApi.sharedApi.token!.CheckToken(email,password: password){
            (isError:Bool, result:String)in

            if(!isError){
                self.mEmail = email
                self.mPassword = password
            
            }
            
            
                completion(isError, result)

            }

    }
    /**
     ChangePassword
     Función que permite  cambiar el password
     
     @param password_old Contraseña antigua
     @param new_password Contraseña nueva
     @param completion Funcíon callback
     
     */
    
    func ChangePassword(_ token:String,password_old:String, new_password:String, completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
        
        ArSmartApi.sharedApi.token!.CheckToken(self.mEmail!,password: password_old){
            (isError:Bool, result:String)in
            
            
            let headers = [
                "Authorization": "JWT "+token,
                "Accept": "application/json"
            ]
            
            let parameters: [String: String] = [
                "old_password" : password_old,
                "new_password" : new_password,
                ]
            
            let endpoint = ArSmartApi.sharedApi.ApiUrl(Api.UserManagement.ChangePassword1)
            
            if(!isError){
                Alamofire.request(endpoint, method:.put, parameters:parameters, encoding: JSONEncoding.default, headers:headers)
                    .validate()
                    .responseJSON { response  in
                        switch response.result {
                            
                        case .success:
                            
                            print(response.response)
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                                
                            }
                            completion(false, "")
                            
                            
                        case .failure:
                            let data = NSData(data: response.data!) as Data
                            var json = JSON(data: data)
                            let response_string = (json["ERROR"]).rawString()
                            completion(true,response_string!)
                        }
                        
                        
                }
            }else{
                //TODO: Si es verdadero, cambielo, de lo contrario no
                
                completion(true,result)
            }
            
            
            
        
            
        }
        
    }
    
    
    
    /**
     RecoverPassword
     Función que permite recuperar la contraseña
     
     @param email CCorreo elexctrónico representado en tipo de datos String.
     @param completion Funcíon callback
     
     */
    static func RecoverPassword(_ email:String, completion: @escaping (_ IsError:Bool,_ result: String) -> Void){
    
        
        let hasInternet = ArSmartUtils.connectedToNetwork()
        
        if(!hasInternet){
            completion(true,"The device is offline, check your internet connection")
            return
        }
        
        
        let parameters: [String: String] = [
            "email" : email ,
            "new_password" : ArSmartUtils.randomText(12,justLowerCase:false),
            ]

        Alamofire.request(ArSmartApi.sharedApi.ApiUrl(Api.UserManagement.ChangePassword),method:.post,parameters:parameters,encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .success:
                    
                    print(response.response)
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        
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
