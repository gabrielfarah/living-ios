//
//  HueEndpointCellTableViewCell.swift
//  Living
//
//  Created by Nelson FB on 31/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class HueEndpointCell: UITableViewCell {

    
    
    @IBOutlet weak var btn_hue: UIButton!
    
    @IBOutlet weak var btn_color: UIButton!
    @IBOutlet weak var lbl_hue: UILabel!
    @IBOutlet weak var slider_intensity: UISlider!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func IntensityValueChanged(sender: AnyObject) {
    }
    @IBAction func ChamgeColor(sender: AnyObject) {
    }
    @IBAction func TurnHue(sender: AnyObject) {
    }

}
