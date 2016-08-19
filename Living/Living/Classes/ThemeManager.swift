//
//  ThemeManager.swift
//  Living
//
//  Created by Nelson FB on 23/06/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import UIKit
import UIColor_Hex_Swift

public class ThemeManager{
    
    
    
    enum ColorLevel{
        case MainColor,ColorAlto,ColorMedio,ColorBajo1,ColorBajo2,ColorLineas,ColorElementos,ColorSoporte,ColorAlertas,ColorActivar;
    
    }
    

    public var MainColor:String
    public var ColorAlto:String
    public var ColorMedio:String
    public var ColorBajo1:String
    public var ColorBajo2:String
    public var ColorLineas:String
    public var ColorElementos:String
    public var ColorSoporte:String
    public var ColorAlertas:String
    public var ColorActivar:String
    
    init(){
    
        self.MainColor = ""
        self.ColorAlto = ""
        self.ColorMedio = ""
        self.ColorBajo1 = ""
        self.ColorBajo2 = ""
        self.ColorLineas = ""
        self.ColorElementos = ""
        self.ColorSoporte = ""
        self.ColorAlertas = ""
        self.ColorActivar = ""
        
        self.setDefaultColor()
    }
    
    func setDefaultColor(){
        self.MainColor = "#2CC2BE"
        self.ColorAlto = "#2CC2BE"
        self.ColorMedio = "#808080"
        self.ColorBajo1 = "#A4A6A9"
        self.ColorBajo2 = "#F3F3F3"
        self.ColorLineas = "#D1D3D4"
        self.ColorElementos = "#E3E4E5"
        self.ColorSoporte = "#ABE7E5"
        self.ColorAlertas = "#F15A29"
        self.ColorActivar = "#39B54A"
    }
    
    
    func GetUIColor(color:String)->UIColor{
        return UIColor(rgba:color)
    }
    
    func style_button(btn:UIButton,color:ColorLevel){
    
    
        switch color {
        case .MainColor:
            btn.backgroundColor = UIColor(rgba:self.MainColor)
            break
        case .ColorAlto:
            btn.backgroundColor = UIColor(rgba:self.ColorAlto)
            break
        case .ColorMedio:
            btn.backgroundColor = UIColor(rgba:self.ColorMedio)
            break
        case .ColorBajo1:
            btn.backgroundColor = UIColor(rgba: self.ColorBajo1)
            break
        case .ColorBajo2:
            btn.backgroundColor = UIColor(rgba:self.ColorBajo2)
            break
        case .ColorLineas:
            btn.backgroundColor = UIColor(rgba:self.ColorLineas)
            break
        case .ColorElementos:
            btn.backgroundColor = UIColor(rgba:self.ColorElementos)
            break
        case .ColorSoporte:
            btn.backgroundColor = UIColor(rgba:self.ColorSoporte)
            break
        case .ColorAlertas:
            btn.backgroundColor = UIColor(rgba:self.ColorAlertas)
            break
        case .ColorActivar:
            btn.backgroundColor = UIColor(rgba:self.ColorActivar)
            break
            
        default:
            btn.backgroundColor = UIColor(rgba:self.MainColor)
            break
        }
        
    
    
    }
    
    

    
    

}
