//
//  UserModelUtil.h
//  PotatoMall
//
//  Created by taotao on 26/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModelUtil : NSObject

//NSUserDefaults
+ (void)saveUser:(NSString*)account password:(NSString*)password;

+ (NSString*)userAccount;
+ (NSString*)userPassword;

+ (NSString*)encryPwdWithPassword:(NSString*) password;

@end
