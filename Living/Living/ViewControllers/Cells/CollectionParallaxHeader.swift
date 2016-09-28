//
//  File.swift
//  Living
//
//  Created by Nelson FB on 1/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class CollectionParallaxHeader: UICollectionReusableView {
    
    
    var imageView : MainMenuHeaderView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        self.clipsToBounds = true
        
        let bounds = CGRect(x: 0, y: 0, width: frame.maxX, height: frame.maxY)
        
        
        imageView = MainMenuHeaderView()

        self.addSubview(imageView!.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.view.frame = self.bounds
    }
    
}
