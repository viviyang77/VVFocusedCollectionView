//
//  VVFocusedCollectionViewCellSizeObject.swift
//  VVFocusedCollectionView
//
//  Created by Vivi on 2020/6/20.
//  Copyright © 2020 Vivi Yang. All rights reserved.
//

import UIKit

@objcMembers
class VVFocusedCollectionViewCellSizeObject: NSObject {
    
    private var largeCellWidthRatio: CGFloat = 0.3      // large cell width / screen width
    private var smallLargeCellRatio: CGFloat = 0.8      // small cell height / large cell height
    private var cellHeightWidthRatio: CGFloat = 4 / 3   // cell height / cell width
    private var cellSpacingRatio: CGFloat = 0.05        // cell spacing / screen width

    var largeCellSize: CGSize {
        let largeCellWidth = screenWidth * largeCellWidthRatio
        let largeCellHeight = largeCellWidth * cellHeightWidthRatio
        return CGSize(width: largeCellWidth, height: largeCellHeight)
    }
    
    var smallCellSize: CGSize {
        let smallCellWidth = largeCellSize.width * smallLargeCellRatio
        let smallCellHeight = largeCellSize.height * smallLargeCellRatio
        return CGSize(width: smallCellWidth, height: smallCellHeight)
    }
    
    var cellSpacing: CGFloat {
        return screenWidth * cellSpacingRatio
    }
    
    var previewWidth: CGFloat {
        return (screenWidth - largeCellSize.width - cellSpacing * 2) / 2.0
    }
    
    var firstCellPrecedingSpacing: CGFloat {
        return previewWidth + cellSpacing
    }
    
    private var screenWidth: CGFloat = UIScreen.main.bounds.width
    
    override init() {
        super.init()
    }
    
    init(largeCellWidthRatio: CGFloat,
         smallLargeCellRatio: CGFloat,
         cellHeightWidthRatio: CGFloat,
         cellSpacingRatio: CGFloat) {
        
        self.largeCellWidthRatio = largeCellWidthRatio
        self.smallLargeCellRatio = smallLargeCellRatio
        self.cellHeightWidthRatio = cellHeightWidthRatio
        self.cellSpacingRatio = cellSpacingRatio
    }
}
