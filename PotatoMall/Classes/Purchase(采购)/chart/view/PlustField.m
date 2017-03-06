//
//  PlustField.m
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "PlustField.h"

@implementation PlustField

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize viewSize = self.size;
    CGSize letViewSize = {viewSize.height,viewSize.height};
    self.leftView.size = letViewSize;
    self.rightView.size = letViewSize;
}

//- (CGRect)leftViewRectForBounds:(CGRect)bounds
//{
//    CGRect rect = [super leftViewRectForBounds:bounds];
//    rect.origin.x = rect.origin.x + 5;
//    return rect;
//}
//

#pragma mark - setup UI 
- (void)setupUI
{
    //setup left view
    UIImage *leftImage =[UIImage imageNamed:@"login_lock"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:leftImage forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(tapMinusBtn) forControlEvents:UIControlEventTouchUpInside];
    CGRect leftF = CGRectMake(0, 0, 30, 30);
    leftBtn.frame = leftF;
    self.leftView = leftBtn;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    // setup right view
    UIImage *rightImage =[UIImage imageNamed:@"login_lock"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(tapPlusBtn) forControlEvents:UIControlEventTouchUpInside];
    CGRect rightF = CGRectMake(0, 0, 30, 30);
    rightBtn.frame = rightF;
    self.rightView = rightBtn;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    //self
    self.keyboardType = UIKeyboardTypeNumberPad;
    
    //border width  set
    self.layer.borderColor = kBtnDisableStateColor.CGColor;
    self.layer.borderWidth = 0.5;
}
#pragma mark - private methods
- (NSString*)countAfterPlus
{
    int currentCount = [self.text intValue];
    int result = currentCount + 1;
    NSString *countStr = [NSString stringWithFormat:@"%d",result];
    self.text = countStr;
    return countStr;
}

- (NSString*)countAfterMinus
{
    int currentCount = [self.text intValue];
    if (currentCount > 1) {
        int result = currentCount - 1;
        NSString *countStr = [NSString stringWithFormat:@"%d",result];
        self.text = countStr;
        return countStr;
    }else{
        NSString *countStr = [NSString stringWithFormat:@"%d",currentCount];
        return countStr;
    }
}

#pragma mark - selectors
- (void)tapPlusBtn
{
    NSString *countStr = [self countAfterPlus];
    if (self.plusBlock != nil) {
        self.plusBlock(countStr);
    }
}

- (void)tapMinusBtn
{
    NSString *countStr = [self countAfterMinus];
    if (self.minusBlock != nil) {
        self.minusBlock(countStr);
    }
}


@end
