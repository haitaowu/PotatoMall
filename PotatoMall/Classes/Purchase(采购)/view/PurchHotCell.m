//
//  PurchHotCell.m
//  lepregt
//
//  Created by taotao on 6/8/16.
//  Copyright © 2016 Singer. All rights reserved.
//

#import "PurchHotCell.h"
#import "HotCollectionCell.h"
#import "GoodsModel.h"

#define kSectionCount               50
#define kMiddleSectionIdx           25



static NSString * HotCollectionCellID = @"HotCollectionCellID";



@interface PurchHotCell()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)NSTimer *timer;
@end

@implementation PurchHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = flowLayout;
    UINib *collectionNib = [UINib nibWithNibName:@"HotCollectionCell"   bundle:nil];
    [self.collectionView registerNib:collectionNib forCellWithReuseIdentifier:HotCollectionCellID];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
}


#pragma mark -  setter and getter methods
- (void)setSpringHotGoods:(NSArray *)springHotGoods
{
    _springHotGoods = springHotGoods;
    [self.collectionView reloadData];
}


#pragma mark - collectionView  data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.springHotGoods.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotCollectionCell *collectCell = [collectionView dequeueReusableCellWithReuseIdentifier:HotCollectionCellID forIndexPath:indexPath];
    GoodsModel *model = self.springHotGoods[indexPath.item];
    [collectCell setModel:model];
    return collectCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemBlock != nil) {
        GoodsModel *model = self.springHotGoods[indexPath.item];
        self.itemBlock(model);
    }
}

#pragma mark - UIcollectionView flow Layout  delegate
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 16);
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize viewSize = self.collectionView.frame.size;
    CGFloat width = viewSize.width / 2.5;
    CGFloat height = viewSize.height - 8;
    return CGSizeMake(width, height);
}




@end
