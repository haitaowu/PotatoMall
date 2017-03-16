//
//  UIViewController+NavigationBar.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import "LoginViewController.h"



@implementation UIViewController (NavigationBar)

- (void)setNavigationBarMainStyle
{
//    UIColor *navBarColor = kMainNavigationBarColor;
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setTranslucent:NO];
//    [navBar setBarTintColor:navBarColor];
//    [navBar setBackgroundColor:navBarColor];
    [navBar setTintColor:[UIColor whiteColor]];
    
//    UIImage *img_bg = [UIImage imageNamed:@"nav_bgY"];
    UIImage *img_bg = [UIImage imageWithColor:kMainNavigationBarColor];
    [navBar setBackgroundImage:img_bg forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    NSDictionary *navBarAttries = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [navBar setTitleTextAttributes:navBarAttries];
}


- (void)showLoginView
{
    UIStoryboard *loginStory = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UINavigationController *loginNav = [loginStory instantiateViewControllerWithIdentifier:@"loginNav"];
    LoginViewController *rootController = (LoginViewController*)[[loginNav childViewControllers] firstObject];
    rootController.type = kPresentModal;
    [self presentViewController:loginNav animated:YES completion:nil];
}



@end
