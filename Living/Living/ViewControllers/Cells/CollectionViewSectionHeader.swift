//
//  File.swift
//  Living
//
//  Created by Nelson FB on 1/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class CollectionViewSectionHeader: UICollectionReusableView {
    
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.addSubview(label)
        label.frame = self.bounds
        label.text = UICollectionElementKindSectionHeader
    }
}

