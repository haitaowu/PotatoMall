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


@interface UserModelUtil : NSObject

//property
@property (nonatomic,strong)UserModel *userModel;

+(instancetype)sharedInstance;

//account info
- (UserModel*)unArchiveUserModel;
- (void)archiveUserModel:(UserModel*)accounModel;
- (UserState)userState;


//NSUserDefaults
+ (void)saveUser:(NSString*)account password:(NSString*)password;
+ (NSString*)userAccount;
+ (NSString*)userPassword;
+ (NSString*)encryPwdWithPassword:(NSString*) password;

@end
