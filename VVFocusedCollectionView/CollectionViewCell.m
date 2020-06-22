//
//  CollectionViewCell.m
//  VVFocusedCollectionView
//
//  Created by Vivi Yang on 8/11/16.
//  Copyright © 2016 Vivi Yang. All rights reserved.
//

#import "CollectionViewCell.h"
#import "VVFocusedCollectionView-Swift.h"

@interface CollectionViewCell ()

@property (strong, nonatomic) VVFocusedCollectionViewCellSizeObject *cellSizeObject;

@end

@implementation CollectionViewCell

- (void)setCollectionViewCellSizeObject:(VVFocusedCollectionViewCellSizeObject *)cellSizeObject {
    self.cellSizeObject = cellSizeObject;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.cardView = [UIView new];
        self.cardView.layer.cornerRadius = 8;
        self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.cardView];
        [NSLayoutConstraint activateConstraints:@[[self.cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
                                                  [self.cardView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor],
                                                  [self.cardView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor],
                                                  [self.cardView.heightAnchor constraintEqualToAnchor:self.cardView.widthAnchor multiplier:0.62],
        ]];
        
        self.textLabel = [UILabel new];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.textLabel];
        
        NSLayoutConstraint *labelHeightConstraint = [self.textLabel.heightAnchor constraintEqualToConstant:16];
        labelHeightConstraint.priority = UILayoutPriorityDefaultLow;
        [NSLayoutConstraint activateConstraints:@[[self.textLabel.topAnchor constraintGreaterThanOrEqualToAnchor:self.cardView.bottomAnchor],
                                                  [self.textLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
                                                  [self.textLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor],
                                                  [self.textLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor],
                                                  [self.textLabel.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor multiplier:0.1]
        ]];
        
        [self adjustViewWithPercentage:(frame.size.height - self.cellSizeObject.smallCellSize.height) / (self.cellSizeObject.largeCellSize.height - self.cellSizeObject.smallCellSize.height)];
    }
    
    return self;
}

- (void)adjustViewWithPercentage:(CGFloat)percentage {
    self.textLabel.alpha = percentage;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.textLabel.alpha = 1;
}

@end
