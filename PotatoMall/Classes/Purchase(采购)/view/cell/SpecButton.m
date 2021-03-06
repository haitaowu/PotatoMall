//
//  SpecButton.m
//  PotatoMall
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "SpecButton.h"


@implementation SpecButton

#pragma mark - override methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil){
        [self setupUI];
    }
    return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    self.selected = YES;
    return YES;
}

+ (UIFont*)titleHFont
{
    return [UIFont fontWithName:@"Helvetica"size:14.f];
}


#pragma mark - set up 
- (void)setupUI
{
    self.layer.borderColor = kMainNavigationBarColor.CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
}

#pragma mark -  setter and getter methods 
- (void)setSpecDict:(NSDictionary *)specDict
{
    _specDict = specDict;
    
    NSString *name = specDict[kSpecName];
    [self setTitleColor:kMainTitleBlackColor forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageWithColor:kMainNavigationBarColor] forState:UIControlStateSelected];
    self.titleLabel.font = [SpecButton titleHFont];
    [self setTitle:name forState:UIControlStateNormal];
    
}


@end
