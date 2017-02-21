//
//  HTTabbarController.m
//  CustomTabBar
//
//  Created by taotao on 7/24/16.
//  Copyright © 2016 taotao. All rights reserved.
//

#import "HTTabbarController.h"

@interface HTTabbarController ()

@end

@implementation HTTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *homeStory = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UINavigationController *homeNav = [homeStory instantiateViewControllerWithIdentifier:@"HomeNav"];
    [self addSubControllerWithChildControlelr:homeNav imageName:@"TabBar1" selectdImgName:@"TabBar1Sel" title:@"首页"];
    
    UIStoryboard *knowStory = [UIStoryboard storyboardWithName:@"Purchase" bundle:nil];
    UINavigationController *knowNav = [knowStory instantiateViewControllerWithIdentifier:@"PurchaseNav"];
    [self addSubControllerWithChildControlelr:knowNav imageName:@"TabBar2" selectdImgName:@"TabBar2Sel" title:@"采购"];
    
    UIStoryboard *shoppingStory = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    UINavigationController *shoppingNav = [shoppingStory instantiateViewControllerWithIdentifier:@"MeNav"];
    [self addSubControllerWithChildControlelr:shoppingNav imageName:@"TabBar4" selectdImgName:@"TabBar4Sel" title:@"我"];
}


- (void)addSubControllerWithChildControlelr:(UINavigationController*)navController imageName:(NSString*)imgName selectdImgName:(NSString*)selectedImageName title:(NSString*)title
{
    UIViewController *childControl =  [[navController childViewControllers] firstObject];
    childControl.tabBarItem.image = [UIImage imageNamed:imgName];
    childControl.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childControl.tabBarItem.title = title;
    
    //2.set title attributes
    NSMutableDictionary *normalAttri = [NSMutableDictionary dictionary];
    [normalAttri setObject:kMainTitleColor forKey:NSForegroundColorAttributeName];
    [childControl.tabBarItem setTitleTextAttributes:normalAttri forState:UIControlStateNormal];
    
    NSMutableDictionary *selectedAttri = [NSMutableDictionary dictionary];
    [selectedAttri setObject:kMainBackgroundColor forKey:NSForegroundColorAttributeName];
    [childControl.tabBarItem setTitleTextAttributes:selectedAttri forState:UIControlStateSelected];
    
    [self addChildViewController:navController];
}


@end
