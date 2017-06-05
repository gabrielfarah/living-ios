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
    var mode:Int = 0
    
    var image1:UIImage?
    var image2:UIImage?
    
    var isEndpoint = false
    
    @IBOutlet weak var color_view: UIView!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet weak var number_value: UILabel!
    @IBOutlet weak var label_value: UILabel!
    
    func setGalleryItem(_ item:UIImage, text:String) {
        
        image1 = item
        image2 = item.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        itemImageView.image = item
        itemLabel.text = text
        bg_view.layer.cornerRadius = 5.0
        setStatus(endpoint)
        if isEndpoint{
            setCell()
        }
        
        
    }
    func setHeaderColor(color:String?){
        if (color != nil){
            color_view.backgroundColor =  UIColor(color!)
        }else{
            color_view.backgroundColor = UIColor.clear
        }
        
    }
    func setHeaderColor(real_color:UIColor?){
        if (real_color != nil){
            color_view.backgroundColor =  real_color
        }else{
            color_view.backgroundColor = UIColor.clear
        }
        
    }
    
    func setGalleryItemNoStatus(_ item:UIImage, text:String) {
        
        image1 = item
        image2 = item.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        
        itemImageView.image = item
        itemLabel.text = text
        bg_view.layer.cornerRadius = 5.0

        //TODO:Apagado
        itemImageView.tintColor = UIColor("#808080")
    }
    func setColor(_ color:UIColor) {
        
        itemImageView.tintColor = UIColor.blue

        _ = Timer.every(500.ms) { (timer: Timer) in
        
            UIView.animate(withDuration:2.0, animations: {
                self.itemImageView.tintColor =  UIColor.black
            })
            timer.invalidate()
        
        }

        
        
    


    }
    
    
    func setCell(){
    
        if endpoint.ui_class_command == "ui-sensor-multilevel"{
            itemImageView.isHidden = true
            number_value.isHidden = false
            label_value.isHidden = false
            label_value.text = endpoint.sig_type
        
        }else{
            itemImageView.isHidden = false
            number_value.isHidden = true
            label_value.isHidden = true
            label_value.text = ""
        }
        
        
        
        
    }
    
    func setStatus(_ endpoint:Endpoint) {
        self.endpoint = endpoint
        
        color_view.backgroundColor = UIColor(endpoint.color)
        
        if(endpoint.state == 0 ){
            //TODO:Apagado
            itemImageView.image = image2
            itemImageView.tintColor = UIColor("#808080")
        }else if(endpoint.state == -1 ){
            //TODO:Apagado
            itemImageView.image = image2
            itemImageView.tintColor = UIColor("#D1D3D4")
        }else{
            //TODO:Encendido
            itemImageView.image = image1
            itemImageView.tintColor = UIColor("#2CC2BE")
        }
        self.setNeedsDisplay()
        
    }
    
    
}
