//
//  HueEndpointCellTableViewCell.swift
//  Living
//
//  Created by Nelson FB on 31/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class HueEndpointCell: UITableViewCell {

    
    
    
    var light:HueLight?
    var group:HueGroup?
    var delegate:HueEndpointCellDelegate?
    
    @IBOutlet weak var btn_hue: UIButton!
    
    @IBOutlet weak var btn_color: UIButton!
    @IBOutlet weak var lbl_hue: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func IntensityValueChanged(_ sender: AnyObject) {
    }
    @IBAction func ChamgeColor(_ sender: AnyObject) {
        delegate?.ShowColorPicker(light!)
        
    }
    @IBAction func TurnHue(_ sender: AnyObject) {
    }
    
    func setLight(_ light:HueLight){
        let image = UIImage(named: "hue_icon1.png")?.withRenderingMode(.alwaysTemplate)
        btn_hue.setImage(image, for: UIControlState())
        
        let xycolor = light.xyToRgb()
        btn_hue.tintColor = UIColor(red: CGFloat(xycolor.0),green:CGFloat(xycolor.1),blue:CGFloat(xycolor.2),alpha:1)
        self.light = light
        
    }
    

}
protocol HueEndpointCellDelegate {
    // protocol definition goes here
    func ShowColorPicker(_ light:HueLight)
    func ToggleLight(_ light:HueLight)
    func ShowColorPicker_Group(_ group:HueGroup)
    func ToggleLight_Group(_ group:HueGroup)
    
    
}

