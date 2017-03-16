//
//  UserModelUtil.h
//  PotatoMall
//
//  Created by taotao on 26/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"


typedef enum{
    NoRegister,
    NoCompleted,
    Completed,
} UserState;

typedef void(^FetchAvatarBlock)(UIImage*img);
typedef void(^ChartCountBlock)(NSInteger count);


@interface UserModelUtil : NSObject

//property
@property (nonatomic,strong)UserModel *userModel;
@property (nonatomic,assign)NSInteger chartCount ;

+(instancetype)sharedInstance;


//account info
- (UserModel*)unArchiveUserModel;
- (void)archiveUserModel:(UserModel*)accounModel;
- (UserState)userState;
- (BOOL)isUserLogin;
- (BOOL)isUserFinishedInfo;

/**类型 1:个体种植户 2：种植企业 3：批发商/采购商 4：种薯种植企业 5：农资电商卖家*/
+ (NSString*)userRoleWithType:(NSString*)type;

/**取用户存储在本地的头像数据*/
- (void)avatarImageWithBlock:(FetchAvatarBlock) result;
//购物车商品数量
- (void)chartCountWithBlock:(ChartCountBlock) result;


//NSUserDefaults
+ (void)saveUser:(NSString*)account password:(NSString*)password;
+ (NSString*)userAccount;
+ (NSString*)userPassword;
+ (NSString*)encryPwdWithPassword:(NSString*) password;
+ (void)saveUserpassword:(NSString*)password;
+ (void)saveUserAccount:(NSString*)account;

@end
