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


@interface UserModelUtil : NSObject

//property
@property (nonatomic,strong)UserModel *userModel;

+(instancetype)sharedInstance;

//account info
- (UserModel*)unArchiveUserModel;
- (void)archiveUserModel:(UserModel*)accounModel;
- (UserState)userState;

/**类型 1:个体种植户 2：种植企业 3：批发商/采购商 4：种薯种植企业 5：农资电商卖家*/
+ (NSString*)userRoleWithType:(NSString*)type;

/**取用户存储在本地的头像数据*/
- (void)avatarImageWithBlock:(FetchAvatarBlock) result;


//NSUserDefaults
+ (void)saveUser:(NSString*)account password:(NSString*)password;
+ (NSString*)userAccount;
+ (NSString*)userPassword;
+ (NSString*)encryPwdWithPassword:(NSString*) password;

@end
