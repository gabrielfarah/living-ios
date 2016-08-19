//
//  ArSmartUtils.swift
//  Living
//
//  Created by Nelson FB on 7/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import SystemConfiguration


class ArSmartUtils{

    static func randomText(length: Int, justLowerCase: Bool = false) -> String {
        var text = ""
        for _ in 1...length {
            var decValue = 0  // ascii decimal value of a character
            var charType = 3  // default is lowercase
            if justLowerCase == false {
                // randomize the character type
                charType =  Int(arc4random_uniform(4))
            }
            switch charType {
            case 1:  // digit: random Int between 48 and 57
                decValue = Int(arc4random_uniform(10)) + 48
            case 2:  // uppercase letter
                decValue = Int(arc4random_uniform(26)) + 65
            case 3:  // lowercase letter
                decValue = Int(arc4random_uniform(26)) + 97
            default:  // space character
                decValue = 32
            }
            // get ASCII character from random decimal value
            let char = String(UnicodeScalar(decValue))
            text = text + char
            // remove double spaces
            text = text.stringByReplacingOccurrencesOfString("  ", withString: " ")
        }
        return text
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    
    static func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        var flags : SCNetworkReachabilityFlags = []
        
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
            
            return false
            
        }
        
        let isReachable = flags.contains(.Reachable)
        
        let needsConnection = flags.contains(.ConnectionRequired)
        
        return (isReachable && !needsConnection)
        
    }
    
    static func ParseDate(date:String)->NSDate{
    
        let dateFormatter = NSDateFormatter()
        // 2016-07-07T20:09:50.869429Z
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'A'Z'"/* find out and place date format from http://userguide.icu-project.org/formatparse/datetime */
        let date_native = dateFormatter.dateFromString(date)
        return date_native!
    
    }
    

}
