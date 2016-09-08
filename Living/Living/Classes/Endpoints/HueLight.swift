//
//  HueLight.swift
//  Living
//
//  Created by Nelson FB on 1/09/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class HueLight{

    var light_id:Int
    var reachable:Bool
    var swversion:String
    var type:String
    var colorMode:String
    var on:Bool
    var effect:String
    var manufacturername:String
    var uniqueid:String
    var xy:(Double, Double)
    var saturation:Double
    var name:String
    var modelid:String
    var brightness:Double
    var alert:String
    var hue:Double

    var endpoint:Endpoint
   

    init(light_id:Int,reachable:Bool,swversion:String,type:String,colorMode:String,on:Bool,effect:String,manufacturername:String,uniqueid:String,xy:(Double, Double),saturation:Double,name:String,modelid:String,brightness:Double,alert:String,hue:Double){

        self.light_id = light_id
        self.reachable = reachable
        self.swversion = swversion
        self.type = type
        self.colorMode = colorMode
        self.on = on
        self.effect = effect
        self.manufacturername = manufacturername
        self.uniqueid = uniqueid
        self.xy = xy
        self.saturation = saturation
        self.name = name
        self.modelid = modelid
        self.brightness = brightness
        self.alert = alert
        self.hue = hue
        self.endpoint = Endpoint()


    }
    
    
    //Theory:https://github.com/mikz/PhilipsHueSDKiOS/blob/master/ApplicationDesignNotes/RGB%20to%20xy%20Color%20conversion.md
    func xyToRgb()->(Double, Double, Double){
        
        //Calculate XYZ values Convert using the following formulas:
        let x:Double = self.xy.0 // the given x value
        let y:Double =  self.xy.1 // the given y value
        let z:Double = 1.0 - x - y
        let Y:Double = self.brightness; // The given brightness value
        let X:Double = (Y / y) * x;
        let Z:Double = (Y / y) * z;
    
        //Convert to RGB using Wide RGB D65 conversion
        var r:Double = X * 1.612 - Y * 0.203 - Z * 0.302
        var g:Double = -X * 0.509 + Y * 1.412 + Z * 0.066
        var b:Double = X * 0.026 - Y * 0.072 + Z * 0.962
        
        //Apply reverse gamma correction
        r = r <= 0.0031308 ? 12.92 * r : (1.0 + 0.055) * pow(r, (1.0 / 2.4)) - 0.055
        g = g <= 0.0031308 ? 12.92 * g : (1.0 + 0.055) * pow(g, (1.0 / 2.4)) - 0.055
        b = b <= 0.0031308 ? 12.92 * b : (1.0 + 0.055) * pow(b, (1.0 / 2.4)) - 0.055
        
        return (r,g,b)
        
    }
    //Theory:https://github.com/mikz/PhilipsHueSDKiOS/blob/master/ApplicationDesignNotes/RGB%20to%20xy%20Color%20conversion.md
    func rgbToXY(r:Double,g:Double,b:Double)->(Double, Double){
        
        /*Apply a gamma correction to the RGB values, which makes the color more vivid and more the like the color displayed on the screen of your device. This gamma correction is also applied to the screen of your computer or phone, thus we need this to create the same color on the light as on screen. This is done by the following formulas:*/
        
        let red:Double = (r > 0.04045) ? pow((r + 0.055) / (1.0 + 0.055), 2.4) : (r / 12.92)
        let green:Double = (g > 0.04045) ? pow((g + 0.055) / (1.0 + 0.055), 2.4) : (g / 12.92)
        let blue:Double = (b > 0.04045) ? pow((b + 0.055) / (1.0 + 0.055), 2.4) : (b / 12.92)
        
        let X = red * 0.649926 + green * 0.103455 + blue * 0.197109
        let Y = red * 0.234327 + green * 0.743075 + blue * 0.022598
        let Z = red * 0.0000000 + green * 0.053077 + blue * 1.035763
        
        let x:Double = X / (X + Y + Z);
        let y:Double = Y / (X + Y + Z);
        
        return (x,y)
        
    }
    
    
    static func rgbColorCorrection(rgb:(Double,Double,Double))->(Double,Double,Double){
    
        let r = rgb.0
        let g = rgb.1
        let b = rgb.2
        
        let red:Double = (r > 0.04045) ? pow((r + 0.055) / (1.0 + 0.055), 2.4) : (r / 12.92)
        let green:Double = (g > 0.04045) ? pow((g + 0.055) / (1.0 + 0.055), 2.4) : (g / 12.92)
        let blue:Double = (b > 0.04045) ? pow((b + 0.055) / (1.0 + 0.055), 2.4) : (b / 12.92)
        
        return (red,green,blue)
    }
    
    func setColorById(hub:Int,token:String,rgb:(Double,Double,Double), completion: (IsError:Bool,result: String) -> Void){
        setValueHue(hub, token: token, function: "set_color_to_light_by_id", rgb: rgb) { (IsError, result) in
            completion(IsError: IsError,result:result)
        }
    }
    func setColorByGoup(hub:Int,token:String,rgb:(Double,Double,Double), completion: (IsError:Bool,result: String) -> Void){
        setValueHue(hub, token: token, function: "set_color_to_light_by_group", rgb: rgb) { (IsError, result) in
            completion(IsError: IsError,result:result)
        }
    }
    
    func setValueHue(hub:Int,token:String,function:String,rgb:(Double,Double,Double), completion: (IsError:Bool,result: String) -> Void){
        
        
        
        let headers = [
            "Authorization": "JWT "+token,
            "Accept": "application/json"
        ]
        
        let endpoint = String(format:ArSmartApi.sharedApi.ApiUrl(Api.Hubs.CommandsSet), hub)
        

        var rgb_corrected = HueLight.rgbColorCorrection(rgb)
        
        //[{"type":"wifi","target":"hue","ip":"<IP_DISPOSITIVO>","function":"set_color_to_light_by_id","parameters":["r":100,"g":100,"b":100]}]
        
        let color_parameters = ["r":rgb_corrected.0,"g":rgb_corrected.1,"b":rgb_corrected.2]
        
        let json_parameters: [String: AnyObject]  = [
            "type":"wifi",
            "target":"hue",
            "ip":self.endpoint.ip_address,
            "function":function,
            "parameters":color_parameters
            
        ]
        
        let array = JSON([json_parameters])
        
        
        
        Alamofire.request(.POST,endpoint,headers: headers, parameters:[:], encoding:.Custom({convertible, params in
            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = array.rawString()!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            mutableRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            return (mutableRequest, nil)
        }))
            .validate()
            .responseJSON { response  in
                switch response.result {
                    
                case .Success:
                    
                    
                    completion(IsError: false,result: "")
                    
                    
                case .Failure:
                    let data = NSData(data: response.data!)
                    var json = JSON(data: data)
                    let response_string = (json["ERROR"]).rawString()
                    completion(IsError:true,result: response_string!)
                    
                    
                    
                }
                
                
        }
        
        
        
        
    }
    

    /*
    {
    "light_id" : 1,
    "reachable" : true,
    "swversion" : "66009461",
    "type" : "Color light",
    "colormode" : "hs",
    "on" : false,
    "effect" : "none",
    "manufacturername" : "Philips",
    "uniqueid" : "00:17:88:01:00:c2:9e:e7-0b",
    "xy" : [
    0.435,
    0.405
    ],
    "saturation" : 0,
    "name" : "LivingColors 1",
    "modelid" : "LLC011",
    "brightness" : 127,
    "alert" : "none",
    "hue" : 0
    },*/
    
    

}