//
//  UserModel.h
//  PotatoMall
//
//  Created by taotao on 26/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

//{"user":{"phone":"18061955875","userId":2313,"userName":"18061955875","userType":"1"}}


@interface UserModel : NSObject
/**详情地址*/
@property (nonatomic,copy) NSString *address;
/**市ID*/
@property (nonatomic,strong) NSNumber *cityId;
/**市名称*/
@property (nonatomic,copy) NSString *cityName;
/**头像路径*/
@property (nonatomic,copy) NSString *customerImg;
/**区县ID*/
@property (nonatomic,strong) NSNumber *districtId;
/**区县名称*/
@property (nonatomic,copy) NSString *districtName;
/**昵称*/
@property (nonatomic,copy) NSString *nickName;
/**手机号*/
@property (nonatomic,copy) NSString *phone;
/**省ID*/
@property (nonatomic,strong) NSNumber *proviceId;
/**省名称*/
@property (nonatomic,copy) NSString *proviceName;
/**真实姓名*/
@property (nonatomic,copy) NSString *realName;
/**用户ID*/
@property (nonatomic,strong) NSNumber *userId;
/**用户名称*/
@property (nonatomic,copy) NSString *userName;
/**用户*/
@property (nonatomic,copy) NSString *userType;

@end
