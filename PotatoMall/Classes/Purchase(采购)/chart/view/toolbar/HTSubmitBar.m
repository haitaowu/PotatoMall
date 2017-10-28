//
//  HTSubmitBar.m
//  HTCustomToolBarDemo
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HTSubmitBar.h"

@interface HTSubmitBar ()
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *totalLabel;
@property (weak, nonatomic) UIButton *statueBtn;
@property (nonatomic,copy)SubmitBlock  submitBlock;

@end


@implementation HTSubmitBar
#pragma mark - override methods
+ (HTSubmitBar*)customBarWithAllBlock:(SubmitBlock)submitBlock
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HTSubmitBar" owner:nil options:nil];
    HTSubmitBar *customView = (HTSubmitBar*)[nibView objectAtIndex:0];
    customView.submitBlock = submitBlock;
    return customView;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize viewSize = CGSizeMake(kScreenWidth, 44);
    CGFloat width = 120;
    
    CGFloat submitX = viewSize.width - width;
    CGRect submitF = {{submitX,0},{width,viewSize.height}};
    self.statueBtn.frame = submitF;
    
    [self.titleLabel sizeToFit];
    CGSize titleSize = self.titleLabel.size;
    CGFloat titleX = 0;
    CGFloat titleY = (viewSize.height - titleSize.height) * 0.5;
    CGRect titleF = {{titleX,titleY},titleSize};
    self.titleLabel.frame = titleF;
    
    [self.totalLabel sizeToFit];
    CGSize totalSize = self.totalLabel.size;
    CGFloat totalX = CGRectGetMaxX(titleF);
    CGFloat totalY = (viewSize.height - totalSize.height) * 0.5;
    CGRect totalF = {{totalX,totalY},totalSize};
    self.totalLabel.frame = totalF;
    

    CGFloat margin = 1;
    
    if (@available(iOS 11,*)){
        self.statueBtn.x = self.statueBtn.x + margin;
//        self.titleLabel.x = self.titleLabel.x + margin;
    }
    
}


#pragma mark - public methods
+ (HTSubmitBar*)submitBarWithAllBlock:(SubmitBlock)submitBlock
{
    HTSubmitBar *submitBar = [[self alloc] initSubmitBarWithAllBlock:submitBlock];
    return submitBar;
}

- (HTSubmitBar*)initSubmitBarWithAllBlock:(SubmitBlock)submitBlock
{
    self = [super init];
    [self setupUI];
    self.submitBlock = submitBlock;
    return self;
}


- (void)updateTotalPriceTitle:(NSString*)priceStr
{
    self.totalLabel.text = priceStr;
}
#pragma mark - private methods
- (void)setupUI
{
    //
    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    titleLabel.text = @"合计：￥";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
    
    UILabel *totalLabel = [[UILabel alloc] init];
    self.totalLabel = totalLabel;
    totalLabel.text = @"0";
    totalLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:totalLabel];
    
    UIButton *statueBtn = [[UIButton alloc] init];
    self.statueBtn = statueBtn;
    [statueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [statueBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    statueBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    statueBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [statueBtn setBackgroundColor:[UIColor redColor]];
    [statueBtn addTarget:self action:@selector(tapSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:statueBtn];
    
   
}

#pragma mark - selectors
- (IBAction)tapSubmitBtn:(id)sender {
    if (self.submitBlock != nil) {
        self.submitBlock();
    }
}


@end
