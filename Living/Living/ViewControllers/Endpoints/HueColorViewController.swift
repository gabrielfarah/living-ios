//
//  HueColorViewController.swift
//  Living
//
//  Created by Nelson FB on 9/09/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

//
//  HueViewController.swift
//  Living
//
//  Created by Nelson FB on 26/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import Foundation
import SwiftHUEColorPicker

class HueColorViewController: UIViewController, SwiftHUEColorPickerDelegate {
    
    
    var endpoint:Endpoint?
    var hue:Hue?;
    let token = ArSmartApi.sharedApi.getToken()
    let hub = ArSmartApi.sharedApi.hub?.hid
    var hueLight:HueLight?;
    
    var color:UIColor? = UIColor.red

    
    

    @IBOutlet weak var img_hue_light: UIButton!
    @IBOutlet weak var lbl_hue_name: UILabel!
    @IBOutlet weak var colorPicker1: SwiftHUEColorPicker!
    @IBOutlet weak var colorPicker2: SwiftHUEColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img_hue_light.imageView!.image = UIImage(named:"hue_icon1.png" )!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)

        
        colorPicker1.delegate = self
        colorPicker1.direction = SwiftHUEColorPicker.PickerDirection.horizontal
        colorPicker1.type = SwiftHUEColorPicker.PickerType.color
        
        colorPicker2.delegate = self
        colorPicker2.direction = SwiftHUEColorPicker.PickerDirection.horizontal
        colorPicker2.type = SwiftHUEColorPicker.PickerType.saturation
        
        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setText(hueLight!.name)
        

        
        let image = UIImage(named: "hue_icon1.png")?.withRenderingMode(.alwaysTemplate)
        img_hue_light.setImage(image, for: UIControlState())
        let xycolor = hueLight!.xyToRgb()
        let red = CGFloat(xycolor.0) / 255
        let color = UIColor(red: CGFloat(xycolor.0),green:CGFloat(xycolor.1),blue:CGFloat(xycolor.2),alpha:1)
        img_hue_light.tintColor = UIColor(red: CGFloat(xycolor.0),green:CGFloat(xycolor.1),blue:CGFloat(xycolor.2),alpha:1)
        

        colorPicker1.currentColor = color
        colorPicker2.currentColor = color
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - SwiftHUEColorPickerDelegate
    
    func valuePicked(_ color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        //self.view.backgroundColor = color
        //img_hue_light.tintColor = color
        self.color = color
        
        let image = UIImage(named: "hue_icon1.png")?.withRenderingMode(.alwaysTemplate)
        img_hue_light.setImage(image, for: UIControlState())
        img_hue_light.tintColor = color

        
        
        
        switch type {
        case SwiftHUEColorPicker.PickerType.color:
            
            break
            
        case SwiftHUEColorPicker.PickerType.saturation:
            
            break
        default:
            break
            
        }
    }
    
    func valuePickedEnd() {
        //self.view.backgroundColor = color
        //img_hue_light.tintColor = color
        print("after")
        //TODO: Aqui se ejecuta el cambio de color.
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        

        let numComponents = self.color!.cgColor.numberOfComponents;

        let components = self.color!.cgColor.components;
        
        let r:Int = Int(components![0] * 255)
        let g:Int = Int(components![1] * 255)
        let b:Int = Int(components![2] * 255)
        
        hueLight?.setColorByGoup(hub!, token: token, rgb: (Double(r),Double(g),Double(b)),ip:endpoint!.ip_address, completion: { (IsError, result) in
            if IsError{
                
                print("[Error]",result)
                
            }else{
                print("[No Error]",result)
            }
        })
        
        
        
    }

    func setText(_ name:String){
        lbl_hue_name.text = name
    }

    @IBAction func GoBack(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func TurnLight(_ sender: UISwitch) {
        
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        
        
        let numComponents = self.color!.cgColor.numberOfComponents;
        
        let components = self.color!.cgColor.components;
        
        let r:Int = Int(components![0] * 255)
        let g:Int = Int(components![1] * 255)
        let b:Int = Int(components![2] * 255)
        
        if(sender.isOn){
            hueLight?.setTurnOnLight(hub!, token: token, rgb: (Double(r),Double(g),Double(b)),ip:endpoint!.ip_address, completion: { (IsError, result) in
                if IsError{
                    
                    print("[Error]",result)
                    
                }else{
                    print("[No Error]",result)
                }
            })
            
        
        }else{
            
            hueLight?.setTurnOffLight(hub!, token: token, rgb: (Double(r),Double(g),Double(b)),ip:endpoint!.ip_address, completion: { (IsError, result) in
                if IsError{
                    
                    print("[Error]",result)
                    
                }else{
                    print("[No Error]",result)
                }
            })
            
        }
        
    }
    
}

