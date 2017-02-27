//
//  UserModelUtil.m
//  PotatoMall
//
//  Created by taotao on 26/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "UserModelUtil.h"
#import "SecurityUtil.h"

static UserModelUtil *instance = nil;


@implementation UserModelUtil
#pragma mark - override methods
+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return  instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

#pragma mark - public methods
+ (NSString*)encryPwdWithPassword:(NSString*) password
{
    NSString *encryptedPWD = [SecurityUtil encryptAESData:password];
    return encryptedPWD;
}

//存储用户名与密码。
+ (void)saveUser:(NSString*)account password:(NSString*)password
{
    NSString *encryPwd = nil;
    if (password != nil) {
        encryPwd = [self encryPwdWithPassword:password];
    }
    [[NSUserDefaults standardUserDefaults] setObject:encryPwd forKey:kEncryPwdKey];
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:kLoginAccountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//登录的用户名
+ (NSString*)userAccount
{
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginAccountKey];
    return account;
}

//登录的用户密码
+ (NSString*)userPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kEncryPwdKey];
}

@end
