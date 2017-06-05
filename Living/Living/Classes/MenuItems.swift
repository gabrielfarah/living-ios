//
//  MenuItems.swift
//  Living
//
//  Created by Nelson FB on 17/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Localize_Swift

class MenuItems{


    var items = [String]()
    
    
    init(){
        items.append("Home".localized())
        items.append("Devices".localized())
        items.append("Guests".localized())
        items.append("Actions".localized())
        items.append("Rooms".localized())
        items.append("Scenes".localized())
        items.append("My Account".localized())
    }
    
    func count()->Int{
        return self.items.count
    
    }
    
    func objectAtIndex(_ index:Int)->String{
    
        return self.items[index]
    }


}

