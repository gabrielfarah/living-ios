//
//  EdnPointMenuCell.swift
//  Living
//
//  Created by Nelson FB on 27/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import UIKit
import SwiftyTimer
import UIColor_Hex_Swift


class EndPointMenuCell: UICollectionViewCell {
    
    var endpoint:Endpoint = Endpoint();
        var timer_status:NSTimer = NSTimer()
    var theme = ThemeManager()
    
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemLabel: UILabel!
    
    func setGalleryItem(item:UIImage, text:String) {
        itemImageView.image = item
        itemLabel.text = text
        
        setStatus(endpoint)
        
    }
    func setColor(color:UIColor) {
        
        itemImageView.tintColor = UIColor.blueColor()

        var timer = NSTimer.every(500.ms) { (timer: NSTimer) in
        
            UIView.animateWithDuration(3.0, animations: {
                self.itemImageView.tintColor =  UIColor.blackColor()
            })
            timer.invalidate()
        
        }

        
        
    


    }
    
    func setStatus(endpoint:Endpoint) {
        self.endpoint = endpoint
        if(endpoint.state == 0 ){
            //TODO:Apagado
            itemImageView.tintColor = UIColor(rgba:"#808080")
        }else if(endpoint.state == -1 ){
            //TODO:Apagado
            itemImageView.tintColor = UIColor(rgba:"#D1D3D4")
        }else{
            //TODO:Encendido
            itemImageView.tintColor = UIColor(rgba:"#2CC2BE")
        }
        
    }
    
    
}
