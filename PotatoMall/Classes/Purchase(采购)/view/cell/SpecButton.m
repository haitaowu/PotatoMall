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

#pragma mark - set up 
- (void)setupUI
{
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 5;
}

#pragma mark -  setter and getter methods 
- (void)setSpecDict:(NSDictionary *)specDict
{
    _specDict = specDict;
    
    NSString *name = specDict[kSpecName];
    [self setTitleColor:kMainTitleBlackColor forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageWithColor:kMainNavigationBarColor] forState:UIControlStateSelected];
    [self setTitle:name forState:UIControlStateNormal];
    
}


@end
