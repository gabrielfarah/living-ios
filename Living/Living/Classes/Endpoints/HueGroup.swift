//
//  HueGroup.swift
//  Living
//
//  Created by Nelson FB on 1/09/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation

class HueGroup{

    var group_id:Int
    var name:String
    var lights:[HueLight]
    
   
    init(){
        
        self.group_id = 0
        self.name = ""
        self.lights = [HueLight]()
        
    }
    
    init(group_id:Int, name:String,lights:[HueLight]){
    
        self.group_id = group_id
        self.name = name
        self.lights = lights
    
    }
    

}