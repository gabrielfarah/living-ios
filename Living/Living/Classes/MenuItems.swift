//
//  MenuItems.swift
//  Living
//
//  Created by Nelson FB on 17/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation


class MenuItems{


    var items = [String]()
    
    
    init(){
        items.append("Home")
        items.append("Devices")
        items.append("Guests")
        items.append("Actions")
        items.append("Rooms")
        items.append("Scenes")
        items.append("My Account")
    }
    
    func count()->Int{
        return self.items.count
    
    }
    
    func objectAtIndex(_ index:Int)->String{
    
        return self.items[index]
    }


}

