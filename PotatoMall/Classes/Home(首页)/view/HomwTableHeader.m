//
//  HomwTableHeader.m
//  PotatoMall
//
//  Created by taotao on 25/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HomwTableHeader.h"
#import "SDCycleScrollView.h"

@interface HomwTableHeader()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
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
//    NSArray *imgs = @[@"http://static.xianzhongwang.com/Fi0kG4sv9RVle3hMudh6WVcoQUdo",@"http://static.xianzhongwang.com/Fi0kG4sv9RVle3hMudh6WVcoQUdo",@"http://static.xianzhongwang.com/Fi0kG4sv9RVle3hMudh6WVcoQUdo"];
//    self.cycleScrollView.imageURLStringsGroup = imgs;
}

#pragma mark - public methods
- (void)loadAdsWithImages:(id)imgs
{
    self.cycleScrollView.imageURLStringsGroup = imgs;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
//    HTLog(@"tap at index %ld",index);
}
@end
