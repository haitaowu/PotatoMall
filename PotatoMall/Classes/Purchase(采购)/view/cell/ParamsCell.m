//
//  ParamsCell.m
//  PotatoMall
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "ParamsCell.h"

#define kImageBtnTag                1000
#define kParamsBtnTag               1001

#define kParamName                  @"paramName"
#define kParamValue                 @"paramValue"



@interface ParamsCell()
@property (nonatomic,weak)UIView  *containerView;
@property (nonatomic,weak)UIImageView  *imgView;
@property (nonatomic,weak)UIButton  *imageBtn;
@property (nonatomic,weak)UIButton  *paramsStateBtn;
@property (nonatomic,strong)NSMutableArray *paramsLabels;
@end


@implementation ParamsCell

#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}

#pragma mark - lazy methods
-(NSMutableArray *)paramsLabels
{
    if(_paramsLabels== nil)
    {
        _paramsLabels = [[NSMutableArray alloc] init];
    }
    return _paramsLabels;
}

#pragma mark - setup UI
- (void)setupView
{
    self.containerView = [self viewWithTag:555];
    self.imgView = [self viewWithTag:444];
    self.imageBtn = [self viewWithTag:kImageBtnTag];
    self.paramsStateBtn = [self viewWithTag:kParamsBtnTag];
    [self.imageBtn addTarget:self action:@selector(tapImageSpectBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.paramsStateBtn addTarget:self action:@selector(tapParamsSpecBtn) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -  setter and getter methods
- (void)setDetailModel:(GoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    if (detailModel.imageSrc != nil) {
        NSURL *picUrl = [NSURL URLWithString:detailModel.imageSrc];
        UIImage *holderImg = [UIImage imageNamed:@"palcehodler_A"];
        [self.imgView sd_setImageWithURL:picUrl placeholderImage:holderImg];
    }
    
    
    [self.paramsLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [detailModel.goodsParams enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addParamsLabelWithDict:obj index:idx count:[_detailModel.goodsParams count]];
    }];
}

#pragma mark - private methods
- (void)addParamsLabelWithDict:(NSDictionary*)param index:(NSInteger)idx count:(NSInteger)count
{
    NSString *name = param[kParamName];
    NSString *value = param[kParamValue];
    NSString *text = [NSString stringWithFormat:@"%@:%@",name,value];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = kMainTitleBlackColor;
    label.text = text;
    [self.paramsLabels addObject:label];
    [self.containerView addSubview:label];
    
    CGSize containerSize = self.containerView.frame.size;
    CGFloat height = containerSize.height / count;
    CGFloat y = idx * height;
    CGRect labelF = {{0,y},{containerSize.width,height}};
    label.frame = labelF;
}

#pragma mark - selectors
- (void)tapImageSpectBtn
{
    self.imageBtn.selected = YES;
    self.paramsStateBtn.selected = NO;
    self.imgView.hidden = NO;
    self.containerView.hidden = YES;
}

- (void)tapParamsSpecBtn
{
    self.imageBtn.selected = NO;
    self.paramsStateBtn.selected = YES;
    self.imgView.hidden = YES;
    self.containerView.hidden = NO;
}


@end
