//
//  RadiusButton.m
//  MeiXun
//
//  Created by taotao on 5/27/16.
//  Copyright © 2016 taotao. All rights reserved.
//

#import "RadiusButton.h"

@implementation RadiusButton

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
    self.layer.cornerRadius = 5;
}

@end
