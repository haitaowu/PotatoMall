//
//  SubTitleLabel.m
//  PotatoMall
//
//  Created by taotao on 13/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "SubTitleLabel.h"

@implementation SubTitleLabel

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
    self.font = [SubTitleLabel titleHFont];
}

+ (UIFont*)titleHFont
{
    return [UIFont fontWithName:@"Helvetica"size:14.f];
}
@end
