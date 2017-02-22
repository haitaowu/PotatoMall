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
    UIColor *navBarColor = kMainNavigationBarColor;
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:navBarColor];
    [navBar setBackgroundColor:navBarColor];
    [navBar setTintColor:[UIColor whiteColor]];
    UIImage *img_bg = [UIImage imageNamed:@"nav_bg"];
    [navBar setBackgroundImage:img_bg forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    NSDictionary *navBarAttries = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [navBar setTitleTextAttributes:navBarAttries];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
