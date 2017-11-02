//
//  PlantSettingViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlantSettingViewController.h"

@interface PlantSettingViewController ()

@end

@implementation PlantSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"植保操作";
    [self setupBase];
}

#pragma mark - private methods
- (void)setupBase
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    [self reqUnionPlanedInfoWith:params];
}

#pragma mark - requset server
- (void)reqUnionPlanedInfoWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/user_union/findUnionUserByUserId";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD dismiss];
            if (status == StatusTypSuccess) {
                NSDictionary *dataDict = [DataUtil dictionaryWithJsonStr:data];
                NSDictionary *obj = dataDict[@"obj"];
                NSLog(@"obj = %@ data = %@",obj,dataDict);
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

@end
