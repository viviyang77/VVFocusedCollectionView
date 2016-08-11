//
//  VVFocusedCollectionViewLayout.m
//  VVFocusedCollectionView
//
//  Created by Vivi Yang on 8/11/16.
//  Copyright © 2016 Vivi Yang. All rights reserved.
//

#import "VVFocusedCollectionViewLayout.h"

@interface VVFocusedCollectionViewLayout ()

@property (strong, nonatomic) NSMutableArray *arrayOfAttributes;

@end

@implementation VVFocusedCollectionViewLayout


#pragma mark - Required methods

/// Returns the width and height of the collection view’s contents. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size for scrolling purposes.
- (CGSize)collectionViewContentSize {
    
    CGFloat precedingGap = self.smallCellSize.width / 2.0 + self.cellGap;
    
    NSInteger numOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numOfItems == 0) {
        return CGSizeMake(0, CGRectGetHeight(self.collectionView.bounds));
        
    } else if (numOfItems == 1) {
        return CGSizeMake(precedingGap + self.largeCellSize.width, CGRectGetHeight(self.collectionView.bounds));
        
    } else {
        return CGSizeMake(precedingGap + self.largeCellSize.width + self.cellGap + self.smallCellSize.width + (self.cellGap + self.smallCellSize.width) * (numOfItems - 2), CGRectGetHeight(self.collectionView.bounds));
    }
}

/// Return layout information for all items whose view intersects the specified rectangle. Your implementation should return attributes for all visual elements, including cells, supplementary views, and decoration views.
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *arrayOfAttributes = [NSMutableArray array];
    
    // Loop through each section and see if rect intersects any header / cell
    
    // Loop through all cells
    for (int index = 0; index < [self.collectionView numberOfItemsInSection:0]; index++) {
        
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
        UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:cellIndexPath];
        
        if (CGRectIntersectsRect(cellAttributes.frame, rect)) {
            [arrayOfAttributes addObject:cellAttributes];
        }
    }
    
    return arrayOfAttributes;
}

/// Return layout information for items in the collection view. You use this method to provide layout information only for items that have a corresponding cell. Do not use it for supplementary views or decoration views.
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.arrayOfAttributes[indexPath.item];
}

/// Return YES if the collection view requires a layout update or NO if the layout does not need to change. Subclasses can override it and return an appropriate value based on whether changes in the bounds of the collection view require changes to the layout of cells and supplementary views.
- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}


#pragma mark - Optional methods

/// Layout updates occur the first time the collection view presents its content and whenever the layout is invalidated explicitly or implicitly because of a change to the view. During each layout update, the collection view calls this method first to give your layout object a chance to prepare for the upcoming layout operation.
- (void)prepareLayout {
    [super prepareLayout];
    
    
    if (!self.arrayOfAttributes) {
        self.arrayOfAttributes = [NSMutableArray array];
    } else {
        [self.arrayOfAttributes removeAllObjects];
    }
    
    CGFloat precedingGap = self.smallCellSize.width / 2.0 + self.cellGap;
    
    static NSInteger focusedIndex = 0;
    
    CGFloat anchorX = self.collectionView.contentOffset.x + precedingGap;
    
    CGFloat distance, maxDistance, percentage;
    CGFloat maxDiffInSize = self.largeCellSize.width - self.smallCellSize.width;
    
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        CGFloat x, y, w, h;
        
        x = precedingGap + i * (self.smallCellSize.width + self.cellGap);
        
        if (i == 0) {
            x = precedingGap;
        } else {
            x = CGRectGetMaxX([(UICollectionViewLayoutAttributes *)(self.arrayOfAttributes[i - 1]) frame]) + self.cellGap;
        }
        
        if (x == anchorX || (x < anchorX && x + self.smallCellSize.width + self.cellGap > anchorX)) {
            // This is the focused cell!
            focusedIndex = i;
            
        } else if (self.collectionView.contentOffset.x < 0) {
            focusedIndex = 0;
        }
        
        if (i == focusedIndex) {
            
            distance = fabs(anchorX - x);
            maxDistance = self.smallCellSize.width;
            percentage = MAX(0, MIN(1, 1 - distance / maxDistance));    // percentage must be between 0 and 1
            
            w = h = self.smallCellSize.width + percentage * maxDiffInSize;
            
        } else if (i == focusedIndex + 1) {
            
            distance = fabs(anchorX - x);
            maxDistance = self.largeCellSize.width + self.cellGap;
            percentage = MAX(0, MIN(1, 1 - distance / maxDistance));    // percentage must be between 0 and 1
            
            w = h = self.smallCellSize.width + percentage * maxDiffInSize;
            
        } else {
            w = h = self.smallCellSize.width;
        }
        
        y = -(h - self.smallCellSize.height) / 2.0;
        attributes.frame = CGRectMake(x, y, w, h);
        
        [self.arrayOfAttributes addObject:attributes];
    }
}

@end
