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
//    [self reqUnionPlanedInfoWith:params];
}

@end
