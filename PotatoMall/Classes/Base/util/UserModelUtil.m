//
//  UserModelUtil.m
//  PotatoMall
//
//  Created by taotao on 26/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "UserModelUtil.h"
#import "SecurityUtil.h"


#define  kLibPath               NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
#define kAccountInfoPath            [kLibPath stringByAppendingPathComponent:@"accountInfo.data"]


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
#pragma mark -  getter methods 
- (UserModel*)userModel
{
    if (_userModel == nil) {
        return [self unArchiveUserModel];
    }else{
        return _userModel;
    }
}

#pragma mark - public methods
/**类型 1:个体种植户 2：种植企业 3：批发商/采购商 4：种薯种植企业 5：农资电商卖家*/
+ (NSString*)userRoleWithType:(NSString*)type
{
    if ([type isEqualToString:@"1"]) {
        return @"个体种植户";
    }else if ([type isEqualToString:@"2"]) {
        return @"种植企业 ";
    }else if ([type isEqualToString:@"3"]) {
        return @"批发商/采购商";
    }else if ([type isEqualToString:@"4"]) {
        return @"种薯种植企业";
    }else{
        return @"农资电商卖家";
    }
}

- (UserModel*)unArchiveUserModel
{
    _userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kAccountInfoPath];
    return _userModel;
}

- (void)archiveUserModel:(UserModel*)accountModel
{
    _userModel = accountModel;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [NSKeyedArchiver archiveRootObject:accountModel toFile:kAccountInfoPath];
    });
}


- (void)avatarImageWithBlock:(FetchAvatarBlock) result
{
    UserModel *model = self.userModel;
    if (model.avatarData == nil) {
        //                NSString *rurl = [GCQiniuUploadManager downloadPathForKey:model.avatar];
        NSURL *url=[NSURL URLWithString:model.customerImg];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                NSData *data = UIImagePNGRepresentation(image);
                model.avatarData = data;
                [self archiveUserModel:model];
                result(image);
            }
        }];
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            UIImage *imgAvatar = [UIImage imageWithData:model.avatarData];
            dispatch_async(dispatch_get_main_queue(), ^{
                result(imgAvatar);
            });
        });
    }
}

/**是否登录*/
- (UserState)userState
{
    if(self.userModel == nil){
        return NoRegister;
    }else{
        if(self.userModel.userType == nil){
            return NoCompleted;
        }else{
            return Completed;
        }
    }
}

/**加密密码*/
+ (NSString*)encryPwdWithPassword:(NSString*) password
{
    NSString *encryptedPWD = [SecurityUtil encryptAESData:password];
    return encryptedPWD;
}


/**存储用户名与密码*/
+ (void)saveUser:(NSString*)account password:(NSString*)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kLoginPwdKey];
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:kLoginAccountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**登录的用户名*/
+ (NSString*)userAccount
{
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginAccountKey];
    return account;
}

/**登录的用户密码*/
+ (NSString*)userPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLoginPwdKey];
}

@end
