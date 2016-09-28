//
//  Event.swift
//  Living
//
//  Created by Nelson FB on 16/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation

class Event{

    var event_description: String
    var user_name: String
    var datetime: Date
    
    
    init(description: String, user:String, date: Date){
    
        event_description = description
        user_name = user
        datetime = date
    
    }

}
