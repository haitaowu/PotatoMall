//
//  ChartView.m
//  PotatoMall
//
//  Created by taotao on 16/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "ChartView.h"

#define kCountLabelWH               16

@interface ChartView()
@property (nonatomic,weak)UIButton  *chartBtn;
@property (nonatomic,weak)UILabel  *countLabel;
@end

@implementation ChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.chartBtn.frame = self.bounds;
    
    CGFloat labelWH = kCountLabelWH;
    CGFloat labelX = self.width - labelWH;
    CGFloat labelY = 0;
    CGRect labelF = {{labelX,labelY},{labelWH,labelWH}};
    self.countLabel.frame = labelF;
}

- (void)updateCountWithStr:(NSString*)countStr
{
    if ([countStr isEqualToString:@"0"]) {
        self.countLabel.hidden = YES;
    }else{
        self.countLabel.hidden = NO;
        self.countLabel.text = countStr;
    }
}

- (void)setupUI
{
    UIImage *chart = [UIImage imageNamed:@"purchase_chart"];
    UIButton *chartBtn = [[UIButton alloc] init];
    [chartBtn setImage:chart forState:UIControlStateNormal];
    [self addSubview:chartBtn];
    self.chartBtn = chartBtn;
    [chartBtn addTarget:self action:@selector(tapChart) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.font = [UIFont systemFontOfSize:8];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.backgroundColor = [UIColor redColor];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.hidden = YES;
    [self addSubview:countLabel];
    countLabel.layer.cornerRadius = kCountLabelWH / 2;
    countLabel.layer.masksToBounds = YES;
    self.countLabel = countLabel;
}

- (void)tapChart
{
    if (self.chartBlock != nil) {
        self.chartBlock();
    }
}
@end
