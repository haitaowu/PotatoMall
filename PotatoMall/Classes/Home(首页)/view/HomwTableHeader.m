//
//  HomwTableHeader.m
//  PotatoMall
//
//  Created by taotao on 25/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HomwTableHeader.h"
#import "SDCycleScrollView.h"
#import "ArticleModel.h"

@interface HomwTableHeader()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong)NSArray *imgs;
@end

@implementation HomwTableHeader

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
    NSMutableArray *imgArray = [NSMutableArray array];
    for (ArticleModel *obj in imgs){
        NSString *imgSrc = [obj.imgSrc copy];
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
        id sender = self.imgs[index];
        self.adBlock(sender);
    }
}

@end
