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

open class ThemeManager{
    
    
    
    enum ColorLevel{
        case mainColor,colorAlto,colorMedio,colorBajo1,colorBajo2,colorLineas,colorElementos,colorSoporte,colorAlertas,colorActivar;
    
    }
    

    open var MainColor:String
    open var ColorAlto:String
    open var ColorMedio:String
    open var ColorBajo1:String
    open var ColorBajo2:String
    open var ColorLineas:String
    open var ColorElementos:String
    open var ColorSoporte:String
    open var ColorAlertas:String
    open var ColorActivar:String
    
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
    
    
    func GetUIColor(_ color:String)->UIColor{
        return UIColor(color)
    }
    
    func style_button(_ btn:UIButton,color:ColorLevel){
    
    
        switch color {
        case .mainColor:
            btn.backgroundColor = UIColor(self.MainColor)
            break
        case .colorAlto:
            btn.backgroundColor = UIColor(self.ColorAlto)
            break
        case .colorMedio:
            btn.backgroundColor = UIColor(self.ColorMedio)
            break
        case .colorBajo1:
            btn.backgroundColor = UIColor( self.ColorBajo1)
            break
        case .colorBajo2:
            btn.backgroundColor = UIColor(self.ColorBajo2)
            break
        case .colorLineas:
            btn.backgroundColor = UIColor(self.ColorLineas)
            break
        case .colorElementos:
            btn.backgroundColor = UIColor(self.ColorElementos)
            break
        case .colorSoporte:
            btn.backgroundColor = UIColor(self.ColorSoporte)
            break
        case .colorAlertas:
            btn.backgroundColor = UIColor(self.ColorAlertas)
            break
        case .colorActivar:
            btn.backgroundColor = UIColor(self.ColorActivar)
            break

        }
        
    
    
    }
    
    func getColor(_ color:ColorLevel)->UIColor{
        
        
        switch color {
        case .mainColor:
            return UIColor(self.MainColor)
            
        case .colorAlto:
            return UIColor(self.ColorAlto)

        case .colorMedio:
            return UIColor(self.ColorMedio)

        case .colorBajo1:
            return UIColor( self.ColorBajo1)

        case .colorBajo2:
            return UIColor(self.ColorBajo2)

        case .colorLineas:
            return UIColor(self.ColorLineas)

        case .colorElementos:
            return UIColor(self.ColorElementos)

        case .colorSoporte:
            return UIColor(self.ColorSoporte)

        case .colorAlertas:
            return UIColor(self.ColorAlertas)

        case .colorActivar:
            return UIColor(self.ColorActivar)

            

        }
        
        
        
    }

    
    

}
