//
//  VVFocusedCollectionView.swift
//  VVFocusedCollectionView
//
//  Created by Vivi on 2020/6/20.
//  Copyright © 2020 Vivi Yang. All rights reserved.
//

import UIKit

@objc
protocol VVFocusedCollectionViewCellProtocol {
    var frame: CGRect { get }
    
    func adjustView(percentage: CGFloat)
}

@objcMembers
class VVFocusedCollectionView: UICollectionView {

    private(set) var focusedCellIndex = 0
    var cellSizeObject = VVFocusedCollectionViewCellSizeObject()
    
    init(frame: CGRect,
         collectionViewLayout: UICollectionViewLayout,
         cellSizeObject: VVFocusedCollectionViewCellSizeObject) {
        
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        self.cellSizeObject = cellSizeObject
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func didScroll() {
        
        var index = 0
        if contentOffset.x < 0 {
            focusedCellIndex = 0
            index = 0
        } else {
            let point = CGPoint(x: contentOffset.x + cellSizeObject.firstCellPrecedingSpacing, y: 0)
            if let focusedIndexPath = indexPathForItem(at: point) {
                focusedCellIndex = focusedIndexPath.item
                index = focusedCellIndex
            } else {
                let indexPath = IndexPath(item: focusedCellIndex, section: 0)
                if let attributes = layoutAttributesForItem(at: indexPath) {
                    if point.x < attributes.frame.minX {
                        index = focusedCellIndex - 1
                    } else {
                        index = focusedCellIndex
                    }
                } else {
                    index = focusedCellIndex
                }
            }
        }
        
        let totalHeightDifference = cellSizeObject.largeCellSize.height - cellSizeObject.smallCellSize.height
        
        let indexPath = IndexPath(item: index, section: 0)
        if let focusedCell = cellForItem(at: indexPath) as? VVFocusedCollectionViewCellProtocol {
            let heightDifference = focusedCell.frame.height - cellSizeObject.smallCellSize.height
            let percentage = max(0, heightDifference / totalHeightDifference)
            focusedCell.adjustView(percentage: percentage)
        }
        
        if index + 1 < numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: index + 1, section: 0)
            if let nextCell = cellForItem(at: indexPath) as? VVFocusedCollectionViewCellProtocol {
                let heightDifference = nextCell.frame.height - cellSizeObject.smallCellSize.height
                let percentage = max(0, heightDifference / totalHeightDifference)
                nextCell.adjustView(percentage: percentage)
            }
        }
        
        if index + 2 < numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: index + 2, section: 0)
            if let secondNextCell = cellForItem(at: indexPath) as? VVFocusedCollectionViewCellProtocol {
                secondNextCell.adjustView(percentage: 0)
            }
        }
    }
    
    func willEndDragging(velocity: CGPoint,
                         targetContentOffset: CGPoint) -> CGPoint {

        // Get index path for target row
        var target = targetContentOffset
        target.x += cellSizeObject.firstCellPrecedingSpacing
        target.y = cellSizeObject.largeCellSize.height / 2
        
        // Determine if target.x is between two cells
        var focusedIndexPath = indexPathForItem(at: target)
        if focusedIndexPath == nil {
            target.x += cellSizeObject.firstCellPrecedingSpacing
            focusedIndexPath = indexPathForItem(at: target)
        }
        
        guard let indexPath = focusedIndexPath else { return targetContentOffset }
        
        var targetIndex = indexPath.item
        if abs(velocity.x) >= 0.25 {
            // Scroll fast enough

            if velocity.x > 0 {
                targetIndex = focusedCellIndex + 1
            } else {
                targetIndex = focusedCellIndex - 1
            }
        } else {
            if let attributes = layoutAttributesForItem(at: indexPath) {
                let startX = attributes.frame.origin.x
                if target.x > startX + attributes.frame.width / 2.0 {
                    targetIndex = indexPath.item + 1
                }
            }
        }
        
        targetIndex = max(0, min(targetIndex, numberOfItems(inSection: 0) - 1))
        focusedCellIndex = targetIndex
        
        target.x = CGFloat(targetIndex) * (cellSizeObject.smallCellSize.width + cellSizeObject.cellSpacing)
        return target
    }
    
    func scrollTo(indexPath: IndexPath, animated: Bool = true) {
        guard
            indexPath.section < dataSource?.numberOfSections?(in: self) ?? 0 &&
            indexPath.item < dataSource?.collectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            else {
                return
        }
        
        let x = (cellSizeObject.smallCellSize.width + cellSizeObject.cellSpacing) * CGFloat(indexPath.item)
        let width = cellSizeObject.largeCellSize.width + cellSizeObject.firstCellPrecedingSpacing
        focusedCellIndex = indexPath.item
        scrollRectToVisible(CGRect(x: x, y: contentOffset.y, width: width, height: 1),
                            animated: animated)
    }
}
