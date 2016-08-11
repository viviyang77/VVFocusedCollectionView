//
//  CollectionViewCell.h
//  VVFocusedCollectionView
//
//  Created by Vivi Yang on 8/11/16.
//  Copyright © 2016 Vivi Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *smallLabel;
@property (strong, nonatomic) UILabel *largeLabel;

+ (void)setSmallCellSide:(CGFloat)smallCellSide largeCellSide:(CGFloat)largeCellSide;

- (void)setLabelsWithPercentage:(CGFloat)percentage;

@end
