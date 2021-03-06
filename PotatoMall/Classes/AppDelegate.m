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
#import "ArticleDetailModel.h"
#import "GoodsModel.h"



@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

#pragma mark - override methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    [self showViewWithUserState];
    [self.window makeKeyAndVisible];
//    HTLog(@"didFinishLaunchingWithOptions");
    //add servers
    [self registerObserversforNotification];
    //register weixin share
    [self registerWebChatShare];
    
    
    [SVProgressHUD setBackgroundColor:RGBA(0, 0, 0, 0.8)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [self skipWithSchemeUrl:url];
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
//    NSString *urlStr = [url absoluteString];
//    HTLog(@"openURL %@",urlStr);
    [self skipWithSchemeUrl:url];
    
    return  isSuc;
}

#pragma mark WXApiDelegate 微信分享的相关回调
// onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面
- (void)onReq:(BaseReq *)req
{
    HTLog(@"onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面");
}

// 如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面
- (void)onResp:(BaseResp *)resp
{
    HTLog(@"回调处理");
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
    [WXApi registerApp:@"wxb7f5c0499cde499f"];
}

- (void)skipWithSchemeUrl:(NSURL*)url
{
    NSString *abStr = url.absoluteString;
    NSArray *urls = [abStr componentsSeparatedByString:@"//"];
    NSArray *schemes = [[urls lastObject] componentsSeparatedByString:@"?"];
    NSString *skipType = [schemes firstObject];
    NSString *skipID = [schemes lastObject];
    HTLog(@"skipTyp %@ --- skipId%@",skipType,skipID);
    if ([skipType isEqualToString:kArticleSkipType]) {
        UIViewController *rootControl = self.window.rootViewController;
        if ([rootControl isKindOfClass:[UITabBarController class]]) {
            [self naviationControllsPopSubControls];
            UITabBarController *tabBarController = (UITabBarController*)rootControl;
            tabBarController.selectedIndex = 0;
            ArticleDetailModel *articleModel = [[ArticleDetailModel alloc] init];
            articleModel.infoId = skipID;
            NSMutableDictionary *sender = [NSMutableDictionary dictionary];
            sender[kNotiUserInfoKey] = articleModel;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kOpenArticleLinkNotification object:nil userInfo:sender];
            });
        }
    }else{
        if ((skipID != nil) && (![skipID containsString:@"wechat"])){
            UIViewController *rootControl = self.window.rootViewController;
            if ([rootControl isKindOfClass:[UITabBarController class]]) {
                [self naviationControllsPopSubControls];
                UITabBarController *tabBarController = (UITabBarController*)rootControl;
                tabBarController.selectedIndex = 1;
                GoodsModel *articleModel = [[GoodsModel alloc] init];
                articleModel.goodsInfoId = skipID;
                NSMutableDictionary *sender = [NSMutableDictionary dictionary];
                sender[kNotiUserInfoKey] = articleModel;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kOpenProductLinkNotification object:nil userInfo:sender];
                });
        }
            
        }
    }
}

- (void)naviationControllsPopSubControls
{
    UIViewController *rootControl = self.window.rootViewController;
    if ([rootControl isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController*)rootControl;
        for (UIViewController *control in tabBarController.childViewControllers) {
            [control.navigationController popToRootViewControllerAnimated:NO];
        }
    }
}

#pragma mark - update UI methods
- (void)showViewWithUserState
{
    if ([[UserModelUtil sharedInstance] userState] == NoRegister) {
        [self userLoginSuccess];
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
