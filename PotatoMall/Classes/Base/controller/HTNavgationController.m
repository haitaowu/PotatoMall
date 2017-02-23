//
//  HTNavgationController.m
//  PotatoMall
//
//  Created by taotao on 22/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HTNavgationController.h"

@interface HTNavgationController ()

@end

@implementation HTNavgationController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarMainStyle];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end
