//
//  Events.swift
//  Living
//
//  Created by Nelson FB on 16/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import SwiftyJSON


class Events{

    
    var events: NSArray
    var objects = [Event]()
    var json_events = [String]()
    
    init(){
        events = NSArray()
        json_events = [String]()
        objects = [Event]()
    }
    
    
    func load(){
    
        self.json_events =   Defaults[.jsonevents]!
        
    
    }
    
    func save(){
        Defaults[.jsonevents] = self.json_events
    
    }
    func clear(){
        self.json_events.removeAll()
    }
    func add(_ event:String){
        self.json_events.append(event)
    }
    func removeAtIndex(_ index:Int){
    
        self.json_events.remove(at: index)
    
    }
    func bind(){
    
        for item in self.json_events{
        
            _ = JSON(item)
           // var event = Event(json.)
        
        }
    
    
    }
    
    
    
    

}
extension DefaultsKeys {
    static let jsonevents = DefaultsKey<[String]?>("jsonevents")

}
