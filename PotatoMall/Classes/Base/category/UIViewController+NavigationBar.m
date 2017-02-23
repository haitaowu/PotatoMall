//
//  UIViewController+NavigationBar.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "UIViewController+NavigationBar.h"

@implementation UIViewController (NavigationBar)

- (void)setNavigationBarMainStyle
{
    UIColor *navBarColor = kMainNavigationBarColor;
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:navBarColor];
    [navBar setBackgroundColor:navBarColor];
    [navBar setTintColor:[UIColor whiteColor]];
    UIImage *img_bg = [UIImage imageNamed:@"nav_bg_empty"];
    [navBar setBackgroundImage:img_bg forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    NSDictionary *navBarAttries = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [navBar setTitleTextAttributes:navBarAttries];
}
@end
