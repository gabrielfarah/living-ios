//
//  NotificationViewCell.swift
//  Living
//
//  Created by Nelson FB on 19/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class NotificationViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_item_text: UILabel!
    @IBOutlet weak var lbl_date_text: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
