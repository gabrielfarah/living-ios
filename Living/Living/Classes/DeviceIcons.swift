//
//  DeviceIcons.swift
//  Living
//
//  Created by Nelson FB on 28/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//



class DeviceIcons{

    var icons: [String] ;
    
    init(){
        icons = [String]();
        readPropertyList();
    }
    
    func readPropertyList() {
        if let URL = Bundle.main.url(forResource: "icons_list", withExtension: "plist") {
            if let englishFromPlist = NSArray(contentsOf: URL) as? [String] {
                for myEnglish in englishFromPlist {
                    icons.append(myEnglish)
                }
            }
        }
    }
    
    
    
    
    
    
    
}
