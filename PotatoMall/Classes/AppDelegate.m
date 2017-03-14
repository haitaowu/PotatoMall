//
//  AppDelegate.m
//  PotatoMall
//
//  Created by taotao on 21/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "AppInfoHelper.h"
#import "HTNavgationController.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

#pragma mark - override methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    [self showViewWithUserState];
    [self.window makeKeyAndVisible];
    
    //add servers
    [self registerObserversforNotification];
    
    //register weixin share
    [self registerWebChatShare];
    
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    HTLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}

#pragma mark WXApiDelegate 微信分享的相关回调
// onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面
- (void)onReq:(BaseReq *)req
{
    NSLog(@"onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面");
}

// 如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面
- (void)onResp:(BaseResp *)resp
{
    NSLog(@"回调处理");
    // 处理 分享请求 回调
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"分享成功!"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
                
            default:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"分享失败!"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
        }
    }
}

#pragma mark - private methods
- (void)registerWebChatShare
{
    [WXApi registerApp:@"wxd930ea5d5a258f4f"];
}

#pragma mark - update UI methods
- (void)showViewWithUserState
{
    if ([[UserModelUtil sharedInstance] userState] == NoRegister) {
        [self setupLoginView];
    }else if ([[UserModelUtil sharedInstance] userState] == NoCompleted) {
        [self setupLoginView];
    }else{
        [self userLoginSuccess];
    }
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutSuccess) name:kUserLogoutSuccessNotification object:nil];
}

#pragma mark - update ui
- (void)userLogoutSuccess
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UITabBarController *loginNav = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginNav"];
    self.window.rootViewController = loginNav;
}

//用户选择阶段 进入主界面
- (void)userLoginSuccess
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabbarController"];
    self.window.rootViewController = tabBarController;
}


@end
