//
//  PersonPlanApplyOptController.m
//  PotatoMall
//
//  Created by taotao on 2017/11/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PersonPlanApplyOptController.h"
#import "plantmodel.h"


#define kNoPlanedSectionIdx             0
#define kPlaningSectionIdx                   1

@interface PersonPlanApplyOptController ()<UIAlertViewDelegate>
@property(nonatomic,assign) BOOL isNoticedReused;
@property(nonatomic,strong) NSDictionary *planInfo;

@end

@implementation PersonPlanApplyOptController

- (void)viewDidLoad {
    [super viewDidLoad];
    //2.查询种植信息
    __block typeof(self) blockSelf = self;
    NSDictionary *paramsPlantedInfo = [self platInfoParams];
    [self detailUserPlat:paramsPlantedInfo withBlock:^(NSDictionary *info) {
        blockSelf.planInfo = info;
    }];
}

#pragma mark - private methods
/*0暂无模板 1正在审核 2审核通过 3 申请被驳回 4 该用户以个体户进行植保计划，无法加入联合体*/
//审核通过
- (BOOL)isPlaned
{
    if ([self.planState isEqualToString:@"2"]) {
        return YES;
    }else{
        return NO;
    }
}
//审核中...
- (BOOL)isReviewing
{
    if ([self.planState isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

//被拒
- (BOOL)isRefused
{
    if ([self.planState isEqualToString:@"3"]) {
        return YES;
    }else{
        return NO;
    }
}

//submit
- (void)submitPersonPlanApply
{
    if (self.planInfo != nil) {
        NSDictionary *params = [self paramPlanted];
        [self reqPlantedPlanWith:params];
    }else{
        //2.查询种植信息
        __block typeof(self) blockSelf = self;
        NSDictionary *paramsPlantedInfo = [self platInfoParams];
        [self detailUserPlat:paramsPlantedInfo withBlock:^(NSDictionary *info) {
            blockSelf.planInfo = info;
            NSDictionary *params = [self paramPlanted];
            [self reqPlantedPlanWith:params];
        }];
    }
}

#pragma mark - selectors
- (IBAction)tapApplyBtn:(id)sender {
    if ([self isRefused]) {
        if (self.isNoticedReused == NO) {
            NSString *title = @"注意";
            NSString *message = @"您上一次的个人植保计划申请被官方驳回，请联系客服询问原因，或者尝试再次提交申请";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
            alert.tag = 0;
            [alert show];
        }else{
            [self submitPersonPlanApply];
        }
    }else{
        NSString *title = @"注意";
        NSString *message = @"一旦以个体种植户身份获得植保计划之后，将在该种植期间内无法挤入任何联合体！您是否仍要申请个体植保计划";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
        alert.tag = 1;
        [alert show];
    }
}

#pragma mark - alertView delegate
//按钮点击事件的代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clickButtonAtIndex:%d",(int)buttonIndex);
    
    if(alertView.tag == 0){
        if(buttonIndex == 1){
            self.isNoticedReused = YES;
        }
    }
    
    if(alertView.tag == 1){
        if(buttonIndex == 1){
            [self submitPersonPlanApply];
        }
    }
    //index为-1则是取消，
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
    if (indexPath.section == kNoPlanedSectionIdx) {
        if (indexPath.row == 0) {
            return 120;
        }else{
            return 250;
        }
    }else {
        return kScreenHeight;
    }
}
    

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kNoPlanedSectionIdx) {
//        if ([[UserModelUtil sharedInstance] isAdminRole]) {
        if ([self isReviewing] == YES) {
            return 0;
        }else{
            return 2;
        }
//        }else{
//            return 0;
//        }
    }else {
        if ([self isReviewing] == YES) {
            return 1;
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
    if ((self.unionId != nil) && (self.unionId != nil)){
        params[@"unionId"] = self.unionId;
    }
    params[@"userId"] = model.userId;
    //1 联合体 2 个体户
    params[@"type"] = @"2";
    //植保品种
    NSString *platType = [self.planInfo strValueForKey:@"platType"];
    params[@"planType"] = platType;
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
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
//                [SVProgressHUD showSuccessWithStatus:msg];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
//            NSLog(@"planted type =%@",type);
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
}



//查询种植信息-请求参数
- (NSDictionary *)platInfoParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    return params;
}


//查询种植信息
- (void)detailUserPlat:(NSDictionary*)params withBlock:(void(^)(NSDictionary *info))resultBlock
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/user/detailUserPlat";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
//                [SVProgressHUD showSuccessWithStatus:msg];
                [SVProgressHUD dismiss];
                NSDictionary *plantedInfo = [plantmodel plantWithData:data];
                NSLog(@"plantedInfo=%@",plantedInfo);
                resultBlock(plantedInfo);
            }else{
                resultBlock(nil);
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            resultBlock(nil);
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
}




@end
