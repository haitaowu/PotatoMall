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



@interface ParamsCell()<UIWebViewDelegate>
@property (nonatomic,weak)UIView  *containerView;
//@property (nonatomic,weak)UIImageView  *imgView;
@property (nonatomic,weak)UIWebView  *webView;
@property (nonatomic,weak)UIButton  *imageBtn;
@property (nonatomic,weak)UIButton  *paramsStateBtn;
@property (nonatomic,strong)NSMutableArray *paramsLabels;
@property (nonatomic,assign) CGFloat labelsHeight;
@property (nonatomic,assign) CGFloat imgsHeight;
@end


#define kParamsLabelHeight              44

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
//    self.imgView = [self viewWithTag:444];
    self.webView = [self viewWithTag:99];
    [self.webView setDelegate:self];
    self.imageBtn = [self viewWithTag:kImageBtnTag];
    self.imageBtn.titleLabel.font = [TitleLabel titleHFont];
    self.paramsStateBtn = [self viewWithTag:kParamsBtnTag];
    self.paramsStateBtn.titleLabel.font = [TitleLabel titleHFont];
    [self.imageBtn addTarget:self action:@selector(tapImageSpectBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.paramsStateBtn addTarget:self action:@selector(tapParamsSpecBtn) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -  setter and getter methods
- (void)setDetailModel:(GoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
//    if (detailModel.imageSrc != nil) {
//        NSURL *picUrl = [NSURL URLWithString:detailModel.imageSrc];
//        UIImage *holderImg = [UIImage imageNamed:@"top_placeholder"];
//        [self.imgView sd_setImageWithURL:picUrl placeholderImage:holderImg];
//    }
//    
    [self.webView loadHTMLString:detailModel.moblieDesc baseURL:nil];
    
    [self.paramsLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [detailModel.goodsParams enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addParamsLabelWithDict:obj index:idx count:[_detailModel.goodsParams count]];
    }];
    
    CGFloat height = kParamsLabelHeight * [detailModel.goodsParams  count];
    self.labelsHeight = height;
}

 - (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    CGFloat sHeight = self.webView.scrollView.contentSize.height;
//    HTLog(@"scrollview height %f and %f",height,sHeight);
    if (self.heightBlock != nil) {
        self.heightBlock(ParamsTypeImage,sHeight);
    }
    self.imgsHeight = sHeight;
}

#pragma mark - private methods
- (void)addParamsLabelWithDict:(NSDictionary*)param index:(NSInteger)idx count:(NSInteger)count
{
    NSString *name = param[kParamName];
    NSString *value = param[kParamValue];
    NSString *text = [NSString stringWithFormat:@"%@:%@",name,value];
    TitleLabel *label = [[TitleLabel alloc] init];
    label.textColor = kMainTitleBlackColor;
    label.text = text;
    [self.paramsLabels addObject:label];
    [self.containerView addSubview:label];
    
    CGSize containerSize = self.containerView.frame.size;
    CGFloat height = kParamsLabelHeight;
    CGFloat y = idx * height;
    CGRect labelF = {{0,y},{containerSize.width,height}};
    label.frame = labelF;
}

#pragma mark - selectors
- (void)tapImageSpectBtn
{
    self.imageBtn.selected = YES;
    self.paramsStateBtn.selected = NO;
    self.webView.hidden = NO;
    self.containerView.hidden = YES;
    if (self.heightBlock != nil) {
        self.heightBlock(ParamsTypeLabels,self.imgsHeight);
    }
}

- (void)tapParamsSpecBtn
{
    self.imageBtn.selected = NO;
    self.paramsStateBtn.selected = YES;
    self.webView.hidden = YES;
    self.containerView.hidden = NO;
    if (self.heightBlock != nil) {
        self.heightBlock(ParamsTypeLabels,self.labelsHeight);
    }
    
}


@end
