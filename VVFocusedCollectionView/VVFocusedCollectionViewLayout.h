//
//  VVFocusedCollectionViewLayout.h
//  VVFocusedCollectionView
//
//  Created by Vivi Yang on 8/11/16.
//  Copyright © 2016 Vivi Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVFocusedCollectionViewLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) CGSize smallCellSize;
@property (assign, nonatomic) CGSize largeCellSize;
@property (assign, nonatomic) CGFloat cellGap;

@end
