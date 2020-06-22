//
//  ViewController.m
//  VVFocusedCollectionView
//
//  Created by Vivi Yang on 8/11/16.
//  Copyright © 2016 Vivi Yang. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "VVFocusedCollectionView-Swift.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) VVFocusedCollectionView *collectionView;
@property (strong, nonatomic) VVFocusedCollectionViewCellSizeObject *cellSizeObject;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat largeCellWidthRatio = 0.65;
    CGFloat labelTopSpacing = 12;
    CGFloat labelHeight = 16;
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width * largeCellWidthRatio;
    CGFloat cellHeight = cellWidth * 0.62 + labelTopSpacing + labelHeight;
    self.cellSizeObject = [[VVFocusedCollectionViewCellSizeObject alloc] initWithLargeCellWidthRatio:largeCellWidthRatio
                                                                                 smallLargeCellRatio:0.8
                                                                                cellHeightWidthRatio:cellHeight / cellWidth
                                                                                    cellSpacingRatio:0.08];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    VVFocusedCollectionViewLayout *layout = [VVFocusedCollectionViewLayout new];
    layout.cellSizeObject = self.cellSizeObject;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CGRect frame = CGRectMake(0,
                              self.view.center.y - self.cellSizeObject.largeCellSize.height / 2.0,
                              [UIScreen mainScreen].bounds.size.width,
                              self.cellSizeObject.largeCellSize.height);
    self.collectionView = [[VVFocusedCollectionView alloc] initWithFrame:frame collectionViewLayout:layout cellSizeObject:self.cellSizeObject];
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.clipsToBounds = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.cellSizeObject.firstCellPrecedingSpacing);
    
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.collectionView didScroll];
}

// Adjust the scroll view (collection view) content offset so that it will point to one cell
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    (*targetContentOffset) = [self.collectionView willEndDraggingWithVelocity:velocity
                                                          targetContentOffset:*targetContentOffset];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item != self.collectionView.focusedCellIndex) {
        [self.collectionView scrollToIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setCollectionViewCellSizeObject:self.cellSizeObject];
    
    cell.cardView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld", (long)indexPath.item];
    
    return cell;
}

@end
