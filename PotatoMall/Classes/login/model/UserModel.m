//
//  UserModel.m
//  PotatoMall
//
//  Created by taotao on 26/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "UserModel.h"

#define kArcAddressKey              @"address"
#define kArcCityIdKey               @"cityId"
#define kArcCityNameKey             @"cityName"
#define kArcCustomerImgKey          @"customerImg"
#define kArcDistrictIdKey           @"districtId"
#define kArcDistrictNameKey         @"districtName"
#define kArcNickNameKey             @"nickName"
#define kArcPhoneKey                @"phone"
#define kArcProviceIdKey            @"proviceId"
#define kArcProviceNameKey          @"proviceName"
#define kArcRealNameKey             @"realName"
#define kArcUserIdKey               @"userId"
#define kArcUserNameKey             @"userName"
#define kArcUserTypeKey             @"userType"
#define kArcSexKey                  @"sex"
#define kArcAvatarDataKey           @"avatarData"

@implementation UserModel
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.address forKey:kArcAddressKey];
    [aCoder encodeObject:self.cityId forKey:kArcCityIdKey];
    [aCoder encodeObject:self.cityName forKey:kArcCityNameKey];
    [aCoder encodeObject:self.customerImg forKey:kArcCustomerImgKey];
    [aCoder encodeObject:self.districtId forKey:kArcDistrictIdKey];
    [aCoder encodeObject:self.districtName forKey:kArcDistrictNameKey];
    [aCoder encodeObject:self.nickName forKey:kArcNickNameKey];
    [aCoder encodeObject:self.phone forKey:kArcPhoneKey];
    [aCoder encodeObject:self.proviceId forKey:kArcProviceIdKey];
    [aCoder encodeObject:self.proviceName forKey:kArcProviceNameKey];
    [aCoder encodeObject:self.realName forKey:kArcRealNameKey];
    [aCoder encodeObject:self.userId forKey:kArcUserIdKey];
    [aCoder encodeObject:self.userName forKey:kArcUserNameKey];
    [aCoder encodeObject:self.userType forKey:kArcUserTypeKey];
    [aCoder encodeObject:self.sex forKey:kArcSexKey];
    [aCoder encodeObject:self.avatarData forKey:kArcAvatarDataKey];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.address = [aDecoder decodeObjectForKey:kArcAddressKey];
    self.cityId = [aDecoder decodeObjectForKey:kArcCityIdKey];
    self.cityName = [aDecoder decodeObjectForKey:kArcCityNameKey];
    self.customerImg = [aDecoder decodeObjectForKey:kArcCustomerImgKey];
    self.districtId = [aDecoder decodeObjectForKey:kArcDistrictIdKey];
    self.districtName = [aDecoder decodeObjectForKey:kArcDistrictNameKey];
    self.nickName = [aDecoder decodeObjectForKey:kArcNickNameKey];
    self.phone = [aDecoder decodeObjectForKey:kArcPhoneKey];
    self.proviceId = [aDecoder decodeObjectForKey:kArcProviceIdKey];
    self.proviceName = [aDecoder decodeObjectForKey:kArcProviceNameKey];
    self.realName = [aDecoder decodeObjectForKey:kArcRealNameKey];
    self.userId = [aDecoder decodeObjectForKey:kArcUserIdKey];
    self.userName = [aDecoder decodeObjectForKey:kArcUserNameKey];
    self.userType = [aDecoder decodeObjectForKey:kArcUserTypeKey];
    self.sex = [aDecoder decodeObjectForKey:kArcSexKey];
    self.avatarData = [aDecoder decodeObjectForKey:kArcAvatarDataKey];
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    UserModel *model = [[UserModel allocWithZone:zone] init];
    model.address = [self.address copy];
    model.cityId = [self.cityId copy];
    model.cityName = [self.cityName copy];
    model.customerImg = [self.customerImg copy];
    model.districtId = [self.districtId copy];
    model.districtName = [self.districtName copy];
    model.nickName = [self.nickName copy];
    model.phone = [self.phone copy];
    model.proviceId = [self.proviceId copy];
    model.proviceName = [self.proviceName copy];
    model.realName = [self.realName copy];
    model.userId = [self.userId copy];
    model.userName = [self.userName copy];
    model.userType = [self.userType copy];
    model.userType = [self.userType copy];
    model.avatarData = [self.avatarData copy];
    return model;
}

@end
