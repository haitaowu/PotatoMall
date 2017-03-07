//
//  ProductSpecificationCell.m
//  PotatoMall
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "ProductSpecificationCell.h"

#define kHorizontalMargin       20
#define kVerticalMargin         20
#define kBorderMargin           16

#define kColumnsCount           2




@interface ProductSpecificationCell()
@property (nonatomic,strong)NSMutableArray *specifBtns;
@end

@implementation ProductSpecificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - lazy methods
-(NSMutableArray *)specifBtns
{
    if(_specifBtns== nil)
    {
        _specifBtns = [[NSMutableArray alloc] init];
    }
    return _specifBtns;
}

#pragma mark -  setter and getter methods
- (void)setDetailModel:(GoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    [self.specifBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [detailModel.goodsSpecs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addParamsLabelWithDict:obj index:idx count:[_detailModel.goodsSpecs count]];
    }];
}

#pragma mark - selectors 
- (void)tapSpecifiBtn:(SpecButton*)sender
{
    HTLog(@"tap selected specification ");
    [self updateStateWithCurrentSelectedBtn:sender];
    if(self.specBlock != nil){
        self.specBlock(sender.specDict);
    }
}

#pragma mark - private methods
- (void)updateStateWithCurrentSelectedBtn:(SpecButton*)btn
{
    for (SpecButton *obj in self.specifBtns) {
        if (obj != btn) {
            obj.selected = NO;
        }
    }
}

- (void)addParamsLabelWithDict:(NSDictionary*)param index:(NSInteger)idx count:(NSInteger)count
{
    SpecButton *btn = [[SpecButton alloc] init];
    [btn setSpecDict:param];
    [self.specifBtns addObject:btn];
    [self.contentView addSubview:btn];
    
    CGFloat height = [ProductSpecificationCell itemHeightWithCount:count];
    NSInteger yIdx = [ProductSpecificationCell verticalIdxWithIdx:idx];
    CGFloat y = yIdx * (kVerticalMargin + height) + kVerticalMargin;
    NSInteger xIdx = [ProductSpecificationCell horizontalIdxWithIdx:idx];
    
    CGFloat itemWidth = [ProductSpecificationCell itemWidth];
    CGFloat x = kBorderMargin + (kVerticalMargin + itemWidth) * xIdx;
    CGRect btnF = {{x,y},{itemWidth,height}};
    btn.frame = btnF;
    [btn addTarget:self action:@selector(tapSpecifiBtn:) forControlEvents:UIControlEventTouchUpInside];
}

+ (CGFloat)cellHieghtWithCount:(NSInteger)count
{
    NSInteger rows = [self rowsCountWithCount:count];
    CGFloat itemsHeight = rows * [self itemHeightWithCount:count];
    CGFloat margins = (rows + 1) * kVerticalMargin;
    return (itemsHeight + margins) ;
}

+ (CGFloat)itemHeightWithCount:(NSInteger)count
{
    return 30;
}

+ (CGFloat)itemWidth
{
    return (kScreenWidth - kBorderMargin * 2 - kHorizontalMargin) / 2;
}

+ (NSInteger)rowsCountWithCount:(NSInteger)count
{
    return (count + kColumnsCount - 1) / kColumnsCount;
}

+ (NSInteger)verticalIdxWithIdx:(NSInteger)idx
{
    return (idx / kColumnsCount);
}

+ (NSInteger)horizontalIdxWithIdx:(NSInteger)idx
{
    return (idx % kColumnsCount);
}

@end
