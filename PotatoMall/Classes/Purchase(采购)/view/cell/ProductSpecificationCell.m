//
//  ProductSpecificationCell.m
//  PotatoMall
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "ProductSpecificationCell.h"

#define kHorizontalMargin       8
#define kVerticalMargin         8
#define kBorderMargin           16

#define kColumnsCount           2




@interface ProductSpecificationCell()
@property (nonatomic,strong)NSMutableArray *specifBtns;
@end

@implementation ProductSpecificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)layoutBtnWithBtn:(SpecButton*)btn index:(NSInteger)idx
{
    CGFloat maxXLimit = kScreenWidth - kBorderMargin;
    CGFloat x,y;
    if(idx == 0){
        x = kBorderMargin;
        y = kBorderMargin;
    }else{
        SpecButton *beforeBtn = self.specifBtns[idx - 1];
        CGFloat leftSider = CGRectGetMaxX(beforeBtn.frame) + kVerticalMargin + btn.width;
        if (leftSider > maxXLimit) {
            x = kBorderMargin;
            y = CGRectGetMaxY(beforeBtn.frame) + kVerticalMargin;
        }else{
            x = CGRectGetMaxX(beforeBtn.frame) + kHorizontalMargin;
            y = beforeBtn.y;
        }
    }
    CGRect frame = {{x,y},btn.size};
    btn.frame = frame;
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
    
    //layoutsubview frame
    [self.specifBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self layoutBtnWithBtn:obj index:idx];
    }];
    if (self.cellBlock != nil) {
        SpecButton *btn = [self.specifBtns lastObject];
        CGFloat height = CGRectGetMaxY(btn.frame);
        self.cellBlock(height);
    }
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
    if (idx == 0) {
        btn.selected = YES;
    }
    [self.specifBtns addObject:btn];
    [self.contentView addSubview:btn];
    
//    CGFloat height = [ProductSpecificationCell itemHeightWithCount:count];
//    NSInteger yIdx = [ProductSpecificationCell verticalIdxWithIdx:idx];
//    CGFloat y = yIdx * (kVerticalMargin + height) + kVerticalMargin;
//    NSInteger xIdx = [ProductSpecificationCell horizontalIdxWithIdx:idx];
    
    NSString *name = param[kSpecName];
    CGSize itemSize = [ProductSpecificationCell itemWidthWithStr:name];
    CGFloat x = 0;
    CGFloat y = 0;
    CGRect btnF = {{x,y},itemSize};
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

+ (CGSize)itemWidthWithStr:(NSString*)str
{
    CGFloat height = [CommHelper strHeightWithStr:str font:[SpecButton titleHFont] width:MAXFLOAT];
    CGFloat width = [CommHelper strWidthWithStr:str font:[SpecButton titleHFont] height:height];
    return CGSizeMake((width + 8 * 4), (height + 8 * 2));
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
