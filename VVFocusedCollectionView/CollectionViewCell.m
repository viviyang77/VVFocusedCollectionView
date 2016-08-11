//
//  CollectionViewCell.m
//  VVFocusedCollectionView
//
//  Created by Vivi Yang on 8/11/16.
//  Copyright © 2016 Vivi Yang. All rights reserved.
//

#import "CollectionViewCell.h"

CGFloat smallCellSide;
CGFloat largeCellSide;

@implementation CollectionViewCell

+ (void)setSmallCellSide:(CGFloat)small largeCellSide:(CGFloat)large {
    smallCellSide = small;
    largeCellSide = large;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.smallLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        self.smallLabel.textAlignment = NSTextAlignmentCenter;
        self.smallLabel.textColor = [UIColor whiteColor];
        self.smallLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
        self.smallLabel.adjustsFontSizeToFitWidth = YES;
        self.smallLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.contentView addSubview:self.smallLabel];
        
        self.largeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        self.largeLabel.textAlignment = NSTextAlignmentCenter;
        self.largeLabel.textColor = [UIColor blackColor];
        self.largeLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:28];
        self.largeLabel.adjustsFontSizeToFitWidth = YES;
        self.largeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.largeLabel];
        
        [self setLabelsWithPercentage:(frame.size.height - smallCellSide) / (largeCellSide - smallCellSide)];
    }
    
    return self;
}

// Percentage: 0 indicates that the cell should show small label with alpha of 1,
// and 1 indicates that the cell should show large label with alpha of 1.
- (void)setLabelsWithPercentage:(CGFloat)percentage {
    
    self.smallLabel.alpha = 1 - percentage;
    self.largeLabel.alpha = percentage;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    CGFloat side = self.frame.size.height;
    self.smallLabel.frame = CGRectMake(0, 0, side, side);
    self.largeLabel.frame = CGRectMake(0, 0, side, side);
    
    self.smallLabel.alpha = 1;
    self.largeLabel.alpha = 0;
}

@end
