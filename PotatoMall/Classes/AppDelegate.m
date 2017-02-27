//
//  AppDelegate.m
//  PotatoMall
//
//  Created by taotao on 21/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "AppDelegate.h"
#import "AppInfoHelper.h"
#import "HTNavgationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - override methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    [self setupLoginView];
    [self.window makeKeyAndVisible];
    
    //add servers
    [self registerObserversforNotification];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark - setup UI 
-(void)setupLoginView
{
    UIStoryboard *loginStory = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    HTNavgationController *loginNav = [loginStory instantiateViewControllerWithIdentifier:@"loginNav"];
    self.window.rootViewController = loginNav;
    NSString *devieIdtentifier = [AppInfoHelper currentDeviceIdentifier];
    HTLog(@"identifier = %@",devieIdtentifier);
}

#pragma mark - private methods
- (void)registerObserversforNotification
{
    //add login success  observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:kLoginSuccessNotification object:nil];
}
//用户选择阶段 进入主界面
- (void)userLoginSuccess
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabbarController"];
    self.window.rootViewController = tabBarController;
}


@end
