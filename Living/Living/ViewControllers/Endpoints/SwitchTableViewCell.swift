//
//  SwitchTableViewCell.swift
//  Living
//
//  Created by Nelson FB on 17/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    let MIN_VALUE:Int = 0
    let MAX_VALUE:Int = 255
    

    @IBOutlet weak var swt_control: UISwitch!
    @IBOutlet weak var lbl_endpoint_name: UILabel!
    @IBOutlet weak var img_endpoint: UIImageView!
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
        
        
    }
    
}
