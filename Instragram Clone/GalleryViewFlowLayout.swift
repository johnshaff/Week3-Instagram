//
//  GalleryViewFlowLayout.swift
//  Instragram Clone
//
//  Created by John Shaff on 10/26/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit

class GalleryViewFlowLayout: UICollectionViewFlowLayout {

    var columns: Int
    
    let spacing: CGFloat = 1.0
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var itemWidth: CGFloat {
        let availableWidth = screenWidth - (CGFloat(columns) * spacing)
        return availableWidth / CGFloat(columns)
    }
    
    
    // The initializer throws values up into the class
    init(columns: Int) {
        // when youre subclassing, make sure to initalize your local members first
        self.columns = columns
        
        // then you intialize the super
        super.init()
        
        // the space along the x-axis
        self.minimumLineSpacing = spacing
        
        // the spacing along the y-axis
        self.minimumInteritemSpacing = spacing
        
        self.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
}
