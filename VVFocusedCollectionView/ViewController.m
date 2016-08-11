//
//  ViewController.m
//  VVFocusedCollectionView
//
//  Created by Vivi Yang on 8/11/16.
//  Copyright © 2016 Vivi Yang. All rights reserved.
//

#import "ViewController.h"
#import "VVFocusedCollectionViewLayout.h"
#import "CollectionViewCell.h"

#define SMALL_CELL_SIZE CGSizeMake(90, 90)
#define LARGE_CELL_SIZE CGSizeMake(120, 120)
#define CELL_GAP 10.0
#define PRECEDING_GAP (SMALL_CELL_SIZE.width / 2.0 + CELL_GAP)

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    VVFocusedCollectionViewLayout *layout = [[VVFocusedCollectionViewLayout alloc] init];
    layout.cellGap = CELL_GAP;
    layout.smallCellSize = SMALL_CELL_SIZE;
    layout.largeCellSize = LARGE_CELL_SIZE;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [CollectionViewCell setSmallCellSide:SMALL_CELL_SIZE.width largeCellSide:LARGE_CELL_SIZE.width];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.center.y - SMALL_CELL_SIZE.height / 2.0, [UIScreen mainScreen].bounds.size.width, SMALL_CELL_SIZE.height) collectionViewLayout:layout];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.clipsToBounds = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, [UIScreen mainScreen].bounds.size.width - (SMALL_CELL_SIZE.width / 2.0 + CELL_GAP + LARGE_CELL_SIZE.width));
    
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    static NSInteger focusedCellIndex;
    NSInteger index;
    
    if (scrollView.contentOffset.x <= 0) {
        focusedCellIndex = 0;
        index = 0;
        
    } else {
        CGPoint point = CGPointMake(scrollView.contentOffset.x + PRECEDING_GAP, 0);
        NSIndexPath *focusedIndexPath = [self.collectionView indexPathForItemAtPoint:point];
        
        if (focusedIndexPath) {
            focusedCellIndex = focusedIndexPath.item;
            index = focusedCellIndex;
            
        } else {
            UICollectionViewLayoutAttributes *attr = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:focusedCellIndex inSection:0]];
            
            if (point.x < CGRectGetMinX(attr.frame)) {
                index = focusedCellIndex - 1;
            } else {
                index = focusedCellIndex;
            }
        }
    }
    
    CollectionViewCell *focusedCell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    CGFloat percentage = MAX(0, (focusedCell.frame.size.height - SMALL_CELL_SIZE.height) / (LARGE_CELL_SIZE.height - SMALL_CELL_SIZE.height));
    
    [focusedCell setLabelsWithPercentage:percentage];
    
    if (index + 1 < [self.collectionView numberOfItemsInSection:0]) {
        CollectionViewCell *nextCell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index + 1 inSection:0]];
        percentage = MAX(0, (nextCell.frame.size.height - SMALL_CELL_SIZE.height) / (LARGE_CELL_SIZE.height - SMALL_CELL_SIZE.height));
        [nextCell setLabelsWithPercentage:percentage];
    }
    
    if (index + 2 < [self.collectionView numberOfItemsInSection:0]) {
        CollectionViewCell *secondNextCell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index + 2 inSection:0]];
        [secondNextCell setLabelsWithPercentage:0];
    }
}

// Adjust the scroll view (collection view) content offset so that it will point to one cell
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    // Get index path for target row
    CGPoint target = *targetContentOffset;
    target.x += PRECEDING_GAP;
    
    // Determine if target.x is between two cells
    NSIndexPath *focusedIndexPath = [self.collectionView indexPathForItemAtPoint:(target)];
    
    if (!focusedIndexPath) {
        target.x += CELL_GAP;
        focusedIndexPath = [self.collectionView indexPathForItemAtPoint:(target)];
    }
    
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:focusedIndexPath];
    
    CGFloat rowStartX = attributes.frame.origin.x;
    if (target.x > rowStartX + attributes.frame.size.width / 2.0) {
        focusedIndexPath = [NSIndexPath indexPathForRow:focusedIndexPath.item + 1 inSection:focusedIndexPath.section];
    }
    
    target.x = focusedIndexPath.item * (SMALL_CELL_SIZE.width + CELL_GAP);
    (*targetContentOffset) = target;
}


#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    switch (indexPath.item % 5) {
        case 0:
            cell.backgroundColor = [UIColor redColor];
            break;
        case 1:
            cell.backgroundColor = [UIColor brownColor];
            break;
        case 2:
            cell.backgroundColor = [UIColor purpleColor];
            break;
        case 3:
            cell.backgroundColor = [UIColor blueColor];
            break;
        case 4:
            cell.backgroundColor = [UIColor greenColor];
            break;
        default:
            break;
    }
    
    cell.smallLabel.text = [NSString stringWithFormat:@"SMALL%d", indexPath.item];
    cell.largeLabel.text = [NSString stringWithFormat:@"LARGE%d", indexPath.item];
    
    return cell;
}


@end
