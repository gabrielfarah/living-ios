//
//  CategoryEndpoint.swift
//  Living
//
//  Created by Nelson FB on 26/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation

class CategoryEndpoint{

    var id:Int
    var description:String
    var code:Int
    
    
    init(){
        self.id = 0
        self.description = ""
        self.code = 0
    
    }
    init(id:Int, description:String, code:Int){
        self.id = id
        self.description = description
        self.code = code
        
    }
    
    init(id:Int, description:String){
        self.id = id
        self.description = description
        self.code = 0
        
    }
    init(code:Int, description:String){
        self.id = 0
        self.description = description
        self.code = code
        
    }
}
