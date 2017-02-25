//
//  HTTabbarController.m
//  CustomTabBar
//
//  Created by taotao on 7/24/16.
//  Copyright © 2016 taotao. All rights reserved.
//

#import "HTTabbarController.h"
#import "HTNavgationController.h"

@interface HTTabbarController ()

@end

@implementation HTTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *homeStory = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    HTNavgationController *homeNav = [homeStory instantiateViewControllerWithIdentifier:@"HomeNav"];
    [self addSubControllerWithChildControlelr:homeNav imageName:@"tabhome" selectdImgName:@"tabhome_selt" title:@"首页"];
    
    UIStoryboard *knowStory = [UIStoryboard storyboardWithName:@"Purchase" bundle:nil];
    HTNavgationController *knowNav = [knowStory instantiateViewControllerWithIdentifier:@"PurchaseNav"];
    [self addSubControllerWithChildControlelr:knowNav imageName:@"tabchart" selectdImgName:@"tabchart_selt" title:@"采购"];
    
    UIStoryboard *shoppingStory = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    HTNavgationController *shoppingNav = [shoppingStory instantiateViewControllerWithIdentifier:@"MeNav"];
    [self addSubControllerWithChildControlelr:shoppingNav imageName:@"tabme" selectdImgName:@"tabme_selt" title:@"我"];
}


- (void)addSubControllerWithChildControlelr:(HTNavgationController*)navController imageName:(NSString*)imgName selectdImgName:(NSString*)selectedImageName title:(NSString*)title
{
    UIViewController *childControl =  [[navController childViewControllers] firstObject];
    childControl.tabBarItem.image = [UIImage imageNamed:imgName];
    childControl.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childControl.tabBarItem.title = title;
    
    //.set title attributes selected color
    NSMutableDictionary *normalAttri = [NSMutableDictionary dictionary];
    [normalAttri setObject:kMainTabBarNormalTitleColor forKey:NSForegroundColorAttributeName];
    [childControl.tabBarItem setTitleTextAttributes:normalAttri forState:UIControlStateNormal];
    
    //.set title attributes normal color
    NSMutableDictionary *selectedAttri = [NSMutableDictionary dictionary];
    [selectedAttri setObject:kMainTabBarSelectedTitleColor forKey:NSForegroundColorAttributeName];
    [childControl.tabBarItem setTitleTextAttributes:selectedAttri forState:UIControlStateSelected];
    
    [self addChildViewController:navController];
}


@end
