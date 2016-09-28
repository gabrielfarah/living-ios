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
        var timer_status:Timer = Timer()
    var theme = ThemeManager()
    
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemLabel: UILabel!
    
    func setGalleryItem(_ item:UIImage, text:String) {
        itemImageView.image = item
        itemLabel.text = text
        bg_view.layer.cornerRadius = 5.0
        setStatus(endpoint)
        
    }
    func setColor(_ color:UIColor) {
        
        itemImageView.tintColor = UIColor.blue

        var timer = Timer.every(500.ms) { (timer: Timer) in
        
            UIView.animate(withDuration: 3.0, animations: {
                self.itemImageView.tintColor =  UIColor.black
            })
            timer.invalidate()
        
        }

        
        
    


    }
    
    func setStatus(_ endpoint:Endpoint) {
        self.endpoint = endpoint
        if(endpoint.state == 0 ){
            //TODO:Apagado
            itemImageView.tintColor = UIColor("#808080")
        }else if(endpoint.state == -1 ){
            //TODO:Apagado
            itemImageView.tintColor = UIColor("#D1D3D4")
        }else{
            //TODO:Encendido
            itemImageView.tintColor = UIColor("#2CC2BE")
        }
        self.setNeedsDisplay()
        
    }
    
    
}
