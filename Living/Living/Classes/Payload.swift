//
//  Payload.swift
//  Living
//
//  Created by Nelson FB on 23/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation

class Payload{

    var type:String
    var node:Int
    var value:Int
    var target:String
    var endpoint_id:Int
    var ip:String
    var function_name:String
    var parameters:[String] = [String]()
    var rgb:(Double,Double,Double)
    
/*
    "parameters" : {
    
    },
    "type" : "zwave",
    "node" : 8,
    "v" : 0,
    "target" : "",
    "endpoint_id" : 41,
    "ip" : "",
    "function" : "zwif_level_set"*/
    init(){
        
        self.type = ""
        self.node = 0
        self.value = 0
        self.target = ""
        self.endpoint_id = 0
        self.ip = ""
        self.function_name = ""
        self.parameters = []
        self.rgb = (0,0,0)
        
    }
    init(type:String,node:Int,value:Int,target:String,endpoint_id:Int,ip:String,function_name:String,parameters:[String]){
        
        self.type = type
        self.node = node
        self.value = value
        self.target = target
        self.endpoint_id = endpoint_id
        self.ip = ip
        self.function_name = function_name
        self.parameters = parameters
        self.rgb = (0,0,0)
    
    }
    init(type:String,node:Int,value:Int,target:String,endpoint_id:Int,ip:String,function_name:String,parameters:[String],rgb:(Double,Double,Double)){
        
        self.type = type
        self.node = node
        self.value = value
        self.target = target
        self.endpoint_id = endpoint_id
        self.ip = ip
        self.function_name = function_name
        self.parameters = parameters
        self.rgb = rgb
        
    }
    
    func getDictionary()->[String:AnyObject]{
    
    
        let payload = [
            "parameters" : [:],
            "type" : self.type,
            "node" : self.node,
            "v" : self.value,
            "target" : self.target,
            "endpoint_id" : self.endpoint_id,
            "ip" : self.ip,
            "function" : self.function_name
        ] as [String : Any]
        
        return payload as [String : AnyObject]

    }
    
    func getDictionaryIfIsSonos()->[String:AnyObject]{
    

        if(function_name == "setVolume"){
            let payload = [
                "parameters" :[
                    "volume":self.value
                ],
                "type" : self.type,
                "target" : "sonos",
                "endpoint_id" : self.endpoint_id,
                "ip" : self.ip,
                "function" : self.function_name
            ] as [String : Any]
            return payload as [String : AnyObject]
        }else{
        
            let payload = [
                "parameters" :[:],
                "type" : self.type,
                "target" : "sonos",
                "endpoint_id" : self.endpoint_id,
                "ip" : self.ip,
                "function" : self.function_name
            ] as [String : Any]
            return payload as [String : AnyObject]
        }

    }
    
    func getDictionaryIfIsHue()->[String:AnyObject]{
        
        //turn_on_all_lights
        //let json_parameters2 = ["type":"wifi","target":"hue","ip":ip,"function":"turn_on_all_lights","parameters":[]] as [String : Any]
            let payload = [
                "parameters" :[],
                "type" : self.type,
                "target" : "hue",
                "endpoint_id" : self.endpoint_id,
                "ip" : self.ip,
                "function" : self.function_name
                ] as [String : Any]
            return payload as [String : AnyObject]
        
        
    }
}
