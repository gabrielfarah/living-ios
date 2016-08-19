//
//  PhotoLibraryCell.swift
//  Living
//
//  Created by Nelson FB on 28/06/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import UIKit

class PhotoLibraryCell: UICollectionViewCell {
    
    @IBOutlet var itemImageView: UIImageView!
    
    func setGalleryItem(item:UIImage) {
        itemImageView.image = item
    }
    
}
