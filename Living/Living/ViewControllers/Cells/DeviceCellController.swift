//
//  NotificationViewCell.swift
//  Living
//
//  Created by Nelson FB on 19/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class DeviceCellController: UITableViewCell {
    
    @IBOutlet weak var lbl_type: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var btn_delete: UIButton!
    var selectedEndpoint = 0
    
    var delegate:DeviceCellControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func delete_action(_ sender: AnyObject) {
        delegate?.TryDeleteDevice(selectedIndex: selectedEndpoint)
    }
}

protocol DeviceCellControllerDelegate {
    // protocol definition goes here
    func TryDeleteDevice(selectedIndex:Int)

    
}

