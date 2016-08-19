//
//  Action.swift
//  Living
//
//  Created by Nelson FB on 19/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Action{



    var message:String
    var created_at:String
    
    
    init(){
        self.message = ""
        self.created_at = ""

    }
    init(message:String, created_at:String){
        self.message = message
        self.created_at = created_at
    }





}