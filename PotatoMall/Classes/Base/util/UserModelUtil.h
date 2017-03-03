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

typedef void(^FetchAvatarBlock)(UIImage*);


@interface UserModelUtil : NSObject

//property
@property (nonatomic,strong)UserModel *userModel;

+(instancetype)sharedInstance;

//account info
- (UserModel*)unArchiveUserModel;
- (void)archiveUserModel:(UserModel*)accounModel;
- (UserState)userState;

/**取用户存储在本地的头像数据*/
- (void)avatarImageWithBlock:(FetchAvatarBlock) result;


//NSUserDefaults
+ (void)saveUser:(NSString*)account password:(NSString*)password;
+ (NSString*)userAccount;
+ (NSString*)userPassword;
+ (NSString*)encryPwdWithPassword:(NSString*) password;

@end
