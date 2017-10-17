//
//  HTTextField.m
//  PotatoMall
//
//  Created by taotao on 02/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HTTextField.h"

@implementation HTTextField

#pragma mark - override methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil){
        [self setupUI];
    }
    return self;
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, 8, 20);
}

#pragma mark - setup UI
- (void)setupUI
{
    self.leftView = [[UIView alloc] init];
    self.leftViewMode = UITextFieldViewModeAlways;
}
   

@end
