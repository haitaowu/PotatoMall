//
//  TitleLabel.m
//  PotatoMall
//
//  Created by taotao on 13/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "TitleLabel.h"

@implementation TitleLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupFont];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
       [self setupFont];
    }
    return self;
}

- (void)setupFont
{
    self.font = [TitleLabel titleHFont];
}

+ (UIFont*)titleHFont
{
    return [UIFont fontWithName:@"Helvetica"size:16.f];
}
@end
