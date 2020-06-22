//
//  CollectionViewCell.h
//  VVFocusedCollectionView
//
//  Created by Vivi Yang on 8/11/16.
//  Copyright © 2016 Vivi Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VVFocusedCollectionViewCellSizeObject;

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIView *cardView;
@property (strong, nonatomic) UILabel *textLabel;

- (void)setCollectionViewCellSizeObject:(VVFocusedCollectionViewCellSizeObject *)cellSizeObject;
- (void)adjustViewWithPercentage:(CGFloat)percentage NS_SWIFT_NAME(adjustView(percentage:));

@end

