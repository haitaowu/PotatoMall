//
//  StateRadiusBtn.m
//  MeiXun
//
//  Created by taotao on 5/27/16.
//  Copyright © 2016 taotao. All rights reserved.
//

#import "StateRadiusBtn.h"

@implementation StateRadiusBtn

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIImage *btnDisImg = [UIImage imageWithColor:kBtnDisableStateColor];
    [self setBackgroundImage:btnDisImg forState:UIControlStateDisabled];
    
    UIImage *btnEnableImg = [UIImage imageWithColor:kMainNavigationBarColor];
    [self setBackgroundImage:btnEnableImg forState:UIControlStateNormal];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void)setHighlighted:(BOOL)highlighted
{}
- (void)setSelected:(BOOL)selected
{}
- (void)setAdjustsImageWhenHighlighted:(BOOL)adjustsImageWhenHighlighted
{}

@end
