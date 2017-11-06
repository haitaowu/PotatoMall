//
//  UnionedPlanOptStateController.m
//  PotatoMall
//
//  Created by taotao on 2017/11/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "UnionedPlanOptStateController.h"

#define kAdminNoPlanedSectionIdx             0
#define kPlaningSectionIdx                   1
#define kUserNoPlanedSectionIdx              2

@interface UnionedPlanOptStateController ()

@end

@implementation UnionedPlanOptStateController

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - private methods
/*0暂无模板 1正在审核 2审核通过 3 申请被驳回 4 该用户以个体户进行植保计划，无法加入联合体*/
- (BOOL)isPlaned
{
    if ([self.planState isEqualToString:@"2"]) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)isReviewing
{
    if ([self.planState isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - selectors
- (IBAction)tapApplyBtn:(id)sender {
    NSDictionary *params = [self paramPlanted];
    [self reqPlantedPlanWith:params];
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kAdminNoPlanedSectionIdx) {
        if (indexPath.row == 0) {
            return 120;
        }else{
            return 250;
        }
    }else if (indexPath.section == kPlaningSectionIdx) {
        return kScreenHeight;
    }else{
        return kScreenHeight;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kAdminNoPlanedSectionIdx) {
        if ([[UserModelUtil sharedInstance] isAdminRole]) {
            if ([self isReviewing] == YES) {
                return 0;
            }else{
                return 2;
            }
        }else{
            return 0;
        }
    }else if (section == kPlaningSectionIdx) {
        if ([self isReviewing] == YES) {
            return 1;
        }else{
            return 0;
        }
    }else{
        if ([[UserModelUtil sharedInstance] isAdminRole] == NO) {
            if ([self isReviewing] == NO) {
                return 1;
            }else{
                return 0;
            }
        }else{
            return 0;
        }
    }
}

#pragma mark - requset server
//.申请植保计划 - 请求参数
- (NSDictionary *)paramPlanted
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"2";
    params[@"unionId"] = self.unionId;
    params[@"userId"] = model.userId;
    //1 联合体 2 个体户
    params[@"type"] = @"1";
    //植保品种
    params[@"planType"] = @"1";
    return params;
}

//申请植保计划
- (void)reqPlantedPlanWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"plat/applyPlan";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
//            NSLog(@"planted type =%@",type);
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
}





@end
