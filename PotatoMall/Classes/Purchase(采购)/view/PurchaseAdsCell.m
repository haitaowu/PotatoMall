//
//  PurchaseAdsCell.m
//  PotatoMall
//
//  Created by taotao on 07/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "PurchaseAdsCell.h"
#import "SDCycleScrollView.h"
#import "GoodsModel.h"

@interface PurchaseAdsCell()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong)NSArray *imgs;
@property (nonatomic,strong)NSArray *goodsModels;

@end

@implementation PurchaseAdsCell
#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cycleScrollView.frame = self.contentView.bounds;
}

#pragma mark - setup
- (void)setupUI
{
    UIImage *placeholderImage = [UIImage imageNamed:@"top_placeholder"];
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:placeholderImage];
    [self addSubview:self.cycleScrollView];
}

#pragma mark - public methods
- (void)loadAdsWithModels:(id)models
{
    _goodsModels = models;
    NSMutableArray *imgArray = [NSMutableArray array];
    for (GoodsModel *obj in models){
        NSString *imgSrc = [obj.imageSrc copy];
        if (imgSrc != nil) {
            [imgArray addObject:imgSrc];
        }
    }
    self.imgs = imgArray;
    self.cycleScrollView.imageURLStringsGroup = imgArray;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.adBlock != nil) {
        id sender = self.goodsModels[index];
        self.adBlock(sender);
    }
}

@end
