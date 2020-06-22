//
//  VVFocusedCollectionViewLayout.swift
//  VVFocusedCollectionView
//
//  Created by Vivi on 2020/6/20.
//  Copyright © 2020 Vivi Yang. All rights reserved.
//

import UIKit

@objcMembers
class VVFocusedCollectionViewLayout: UICollectionViewFlowLayout {
    var cellSizeObject = VVFocusedCollectionViewCellSizeObject()
    
    private var focusedIndex = 0
    private var arrayOfAttributes: [UICollectionViewLayoutAttributes] = []

    // MARK: - Required methods
    
    override var collectionViewContentSize: CGSize {
        let itemCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        let collectionViewHeight = collectionView?.bounds.height ?? 0
        if itemCount == 0 {
            return CGSize(width: 0, height: collectionViewHeight)
        } else if itemCount == 1 {
            let width = cellSizeObject.firstCellPrecedingSpacing + cellSizeObject.largeCellSize.width
            return CGSize(width: width, height: collectionViewHeight)
        } else {
            let widthUpToFirstCell = cellSizeObject.firstCellPrecedingSpacing + cellSizeObject.largeCellSize.width
            let widthAfterFistCell = (cellSizeObject.cellSpacing + cellSizeObject.smallCellSize.width) * CGFloat(itemCount - 1)
            let width = widthUpToFirstCell + widthAfterFistCell
            return CGSize(width: width, height: collectionViewHeight)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var arrayOfAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through all cells and see if rect intersects any cell
        for index in 0 ..< (collectionView?.numberOfItems(inSection: 0) ?? 0) {
            let cellIndexPath = IndexPath(item: index, section: 0)
            if let cellAttributes = layoutAttributesForItem(at: cellIndexPath),
                rect.intersects(cellAttributes.frame) {
                arrayOfAttributes.append(cellAttributes)
            }
        }
        return arrayOfAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.item < arrayOfAttributes.count else { return nil }
        return arrayOfAttributes[indexPath.item]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // MARK: - Optional methods
    
    override func prepare() {
        super.prepare()
        
        arrayOfAttributes.removeAll()
        
        let cellSizeRatio = cellSizeObject.largeCellSize.height / cellSizeObject.largeCellSize.width
        let contentOffsetX = collectionView?.contentOffset.x ?? 0
        
        // anchorX is at the min X of the focused cell when scrolling ended
        let anchorX = contentOffsetX + cellSizeObject.firstCellPrecedingSpacing
        
        var distance: CGFloat = 0
        var maxDistance: CGFloat = 0
        var percentage: CGFloat = 0
        
        let maxDiffInSize = cellSizeObject.largeCellSize.width - cellSizeObject.smallCellSize.width
        
        for index in 0 ..< (collectionView?.numberOfItems(inSection: 0) ?? 0) {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            var x, y, w, h: CGFloat
            
            if index == 0 {
                x = cellSizeObject.firstCellPrecedingSpacing
            } else {
                let previousAttribute = arrayOfAttributes[index - 1]
                x = previousAttribute.frame.maxX + cellSizeObject.cellSpacing
            }
            
            let isFocusedCell =
                x == anchorX || (x < anchorX && x + cellSizeObject.smallCellSize.width + cellSizeObject.cellSpacing > anchorX)
            
            if isFocusedCell {
                focusedIndex = index
            } else if contentOffsetX < 0 {
                focusedIndex = 0
            }
            
            if index == focusedIndex {
                distance = abs(anchorX - x)
                maxDistance = cellSizeObject.smallCellSize.width
                percentage = max(0, min(1, 1 - distance / maxDistance))
                
                w = cellSizeObject.smallCellSize.width + percentage * maxDiffInSize
                h = w * cellSizeRatio
            } else if index == focusedIndex + 1 {
                distance = abs(anchorX - x)
                maxDistance = cellSizeObject.largeCellSize.width + cellSizeObject.cellSpacing
                percentage = max(0, min(1, 1 - distance / maxDistance))
                
                w = cellSizeObject.smallCellSize.width + percentage * maxDiffInSize
                h = w * cellSizeRatio
            } else {
                w = cellSizeObject.smallCellSize.width
                h = w * cellSizeRatio
            }
            
            y = (cellSizeObject.largeCellSize.height - h) / 2.0
            attributes.frame = CGRect(x: x, y: y, width: w, height: h)
            arrayOfAttributes.append(attributes)
        }
    }
}
