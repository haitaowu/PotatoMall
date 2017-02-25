//
//  MeController.m
//  PotatoMall
//
//  Created by taotao on 25/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "MeController.h"

@interface MeController ()

@end

@implementation MeController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navBar = [UINavigationBar appearance];
//    [navBar setBarTintColor:navBarColor];
//    [navBar setBackgroundColor:navBarColor];
    [navBar setTintColor:[UIColor whiteColor]];
//    UIImage *img_bg = [UIImage imageNamed:@"nav_bgY"];
//    [navBar setBackgroundImage:img_bg forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
}



@end
