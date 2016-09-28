//
//  WeekDaysSegmentedControl.swift
//  WeekDaysSegmentedControlExample
//
//  Created by Omar Albeik on 5/11/16.
//  Copyright © 2016 Omar Albeik. All rights reserved.
//

import UIKit

@objc protocol WeekDaysSegmentedControlDelegate {
    ///Set when segment changes
    @objc optional func segmentsDidChange(_ control: WeekDaysSegmentedControl, selectedIndexes: [Int])
}

private extension String {
    
    func replace(_ index: Int, newChar: Character) -> String {
        var chars = Array(self.characters) // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
    
}

class WeekDaysSegmentedControl: UIView {
    

    
    
    fileprivate var buttonTitles = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    var borderColor = UIColor("#2CC2BE")
    var textColor = UIColor.darkGray
    var font = UIFont.systemFont(ofSize: 13)
    fileprivate var indexes: [Int] = []
    
    var delegate: WeekDaysSegmentedControlDelegate?
    
    var selectedIndexes: [Int] {
        get {
            return indexes.sorted()
        }
        set {
            indexes = newValue
        }
    }
    
    var daysString: String {
        
        get {
            
            var days = "0000000"
            
            guard selectedIndexes.count > 0 else {
                return days
            }
            
            for index in selectedIndexes {
                days = days.replace(index, newChar: "1")
            }
            return days
        }
        
        set {
            
            guard newValue.characters.count == 7 else {
                print("\(newValue) is not a valid days string")
                return
            }
            
            for (index, element) in newValue.characters.enumerated() {
                if element == "1" {
                    indexes.append(index)
                }
            }
            
        }
        
        
        
    }
    
    override func layoutSubviews() {
        
        self.layer.cornerRadius = 2
        self.layer.borderWidth = 1
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.masksToBounds = true
        
        if self.subviews.count <= 0 {
            
            for (index, title) in buttonTitles.enumerated() {
                let buttonWidth = self.frame.width / CGFloat(buttonTitles.count)
                let buttonHeight = self.frame.height
                
                let button = UIButton(frame: CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth, height: buttonHeight))
                
                button.setTitle(title, for: UIControlState())
                button.setTitleColor(self.textColor, for: UIControlState())
                button.titleLabel?.font = self.font
                button.addTarget(self, action: #selector(self.changeSegment(_:)), for: .touchUpInside)
                button.layer.borderWidth = 1
                button.layer.borderColor = self.borderColor.cgColor
                button.tag = index
                
                for item in indexes {
                    if item == index {
                        button.backgroundColor = borderColor
                        button.setTitleColor(UIColor.white, for: UIControlState())
                    }
                }
                self.addSubview(button)
            }
        }
        
    }
    
    func changeSegment(_ sender: UIButton) {
        
        print(sender.tag)
        
        
        if sender.backgroundColor == borderColor {
            sender.backgroundColor = UIColor.clear
            sender.setTitleColor(textColor, for: UIControlState())
            
            for (index, element) in indexes.enumerated() {
                if element == sender.tag {
                    indexes.remove(at: index)
                }
            }
            
        } else {
            sender.backgroundColor = borderColor
            sender.setTitleColor(UIColor.white, for: UIControlState())
            self.indexes.append(sender.tag)
        }
        
        print(daysString)
        
        delegate?.segmentsDidChange?(self, selectedIndexes: selectedIndexes)
    }
    
    func getDaysArray()->[Int]{

        return selectedIndexes
    
    }
    
    
}
