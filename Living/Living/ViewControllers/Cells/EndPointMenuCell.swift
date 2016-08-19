//
//  EdnPointMenuCell.swift
//  Living
//
//  Created by Nelson FB on 27/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import UIKit

class EndPointMenuCell: UICollectionViewCell {
    
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemLabel: UILabel!
    
    func setGalleryItem(item:UIImage, text:String) {
        itemImageView.image = item
        itemLabel.text = text
    }
    
}
