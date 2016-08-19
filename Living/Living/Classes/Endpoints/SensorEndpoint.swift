//
//  SensorEndpoint.swift
//  Living
//
//  Created by Nelson FB on 10/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//
import Foundation

class SensorEndpoint:Endpoint{
    
    private static let MAX_VALUE = 100
    private static let MIN_VALUE = 0
    
    func SetLevel(level:Int){}
    func On(){
        self.SetLevel(SensorEndpoint.MAX_VALUE)
    }
    func Off(){
        self.SetLevel(SensorEndpoint.MIN_VALUE)
    }
    
    
    
    
    
}