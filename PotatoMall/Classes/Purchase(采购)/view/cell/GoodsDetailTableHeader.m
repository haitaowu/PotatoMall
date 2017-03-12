//
//  GoodsDetailTableHeader.m
//  PotatoMall
//
//  Created by taotao on 25/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "GoodsDetailTableHeader.h"
#import "SDCycleScrollView.h"

@interface GoodsDetailTableHeader()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong)NSArray *imgs;
@end

@implementation GoodsDetailTableHeader

#pragma mark - override methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil){
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cycleScrollView.frame = self.bounds;
}

#pragma mark - setup 
- (void)setupUI
{
    UIImage *placeholderImage = [UIImage imageNamed:@"tudou"];
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:placeholderImage];
    [self addSubview:self.cycleScrollView];
}

#pragma mark - public methods
- (void)loadAdsWithImages:(id)imgs
{
    self.imgs = imgs;
    self.cycleScrollView.imageURLStringsGroup = imgs;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.adBlock != nil) {
        id sender = self.imgs[index];
        self.adBlock(sender);
    }
}

@end
