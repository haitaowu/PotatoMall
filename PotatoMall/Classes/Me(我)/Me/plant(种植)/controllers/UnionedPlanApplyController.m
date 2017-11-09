//
//  UnionedPlanApplyController.m
//  PotatoMall
//
//  Created by taotao on 2017/11/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "plantmodel.h"
#import "UnionedPlanApplyController.h"
#import "BRPickerView.h"



@interface UnionedPlanApplyController ()
@property(nonatomic,strong) NSDictionary *planInfo;
@property(nonatomic,strong) NSMutableArray *cateArray;
@property(nonatomic,strong)  plantmodel *selectedCate;
@property (weak, nonatomic) IBOutlet UIButton *zhongsubutton;
@end

@implementation UnionedPlanApplyController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    //2.查询种植信息
//    __block typeof(self) blockSelf = self;
//    NSDictionary *paramsPlantedInfo = [self platInfoParams];
//    [self detailUserPlat:paramsPlantedInfo withBlock:^(NSDictionary *info) {
//        blockSelf.planInfo = info;
//    }];
    [self findSysDictByType:[self Paramstype:@"2"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - private methods
- (void)setupPickViewWithTitles:(NSArray*)titles title:(NSString*)title defaultTitle:(NSString*)defaultTitle block:(void(^)(NSInteger))block
{
    [BRStringPickerView showSPickerWithTitle:title dataSource:titles resultBlock:^(NSInteger idx, id selectValue) {
        block(idx);
    }];
}

- (BOOL)hasRightToApply
{
    UserModel *userModel = [UserModelUtil sharedInstance].userModel;
    if ([userModel.userType isEqualToString:@"1"]) {
        return YES;
    }else if ([userModel.userType isEqualToString:@"2"]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - selectors
//选择品种
- (IBAction)tapCategoryBtn:(id)sender {
    NSMutableArray *array = [NSMutableArray array];
    for (plantmodel *model in self.cateArray) {
        [array addObject:model.name];
    }
    
    if ([array count] > 0){
        NSArray *titles = array;
        NSString *title = @"种薯";
        NSString *defaultTitle = [array firstObject];
        __weak typeof(self) weakSelf = self;
        [self setupPickViewWithTitles:titles title:title defaultTitle:defaultTitle block:^(NSInteger idx) {
            plantmodel *model = self.cateArray[idx];
            self.selectedCate = model;
            [weakSelf.zhongsubutton setTitle:model.name forState:UIControlStateNormal];
            NSLog(@"model.uid =%@",model.uid);
        }];
    }
}

- (IBAction)tapApplyBtn:(id)sender {
    // 1 创建人 2 管理员 3普通用户
    NSDictionary *params = [self paramPlanted];
    if (params == nil) {
        [SVProgressHUD showInfoWithStatus:@"请选择品种"];
        return;
    }
    if ([self hasRightToApply] == NO) {
        [SVProgressHUD showInfoWithStatus:@"你无此权限"];
        return;
    }
    
    [self reqPlantedPlanWith:params];
    
//    if (self.planInfo != nil) {
//        NSDictionary *params = [self paramPlanted];
//        [self reqPlantedPlanWith:params];
//    }else{
//        //2.查询种植信息
//        __block typeof(self) blockSelf = self;
//        NSDictionary *paramsPlantedInfo = [self platInfoParams];
//        [self detailUserPlat:paramsPlantedInfo withBlock:^(NSDictionary *info) {
//            blockSelf.planInfo = info;
//            NSDictionary *params = [self paramPlanted];
//            [self reqPlantedPlanWith:params];
//        }];
//    }
}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }else{
        return 0.001;
    }
}


#pragma mark - requset server
////查询种植信息-请求参数
//- (NSDictionary *)platInfoParams
//{
//    UserModel *model = [UserModelUtil sharedInstance].userModel;
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[kUserIdKey] = model.userId;
//    params[@"unionId"] = self.unionId;
//    return params;
//}
//
////查询种植信息
//- (void)detailUserPlat:(NSDictionary*)params withBlock:(void(^)(NSDictionary *info))resultBlock
//{
//    if ([RequestUtil networkAvaliable] == NO) {
//    }else{
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
//        NSString *subUrl = @"/user/detailUserPlat";
//        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
//        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
//            if (status == StatusTypSuccess) {
//                //                [SVProgressHUD showSuccessWithStatus:msg];
//                [SVProgressHUD dismiss];
//                NSDictionary *plantedInfo = [plantmodel plantWithData:data];
//                NSLog(@"plantedInfo=%@",plantedInfo);
//                resultBlock(plantedInfo);
//            }else{
//                resultBlock(nil);
//                [SVProgressHUD showErrorWithStatus:msg];
//            }
//        } reqFail:^(int type, NSString *msg) {
//            resultBlock(nil);
//            [SVProgressHUD showErrorWithStatus:msg];
//        }];
//    }
//}


//.申请植保计划 - 请求参数
- (NSDictionary *)paramPlanted
{
    if (self.selectedCate == nil) {
        return nil;
    }
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.unionId != nil){
        params[@"unionId"] = self.unionId;
    }
    params[@"userId"] = model.userId;
    //1 联合体 2 个体户
    params[@"type"] = @"1";
    //植保品种
//    NSString *platType = [self.planInfo strValueForKey:@"platType"];
    params[@"planType"] = self.selectedCate.uid;
    return params;
}


//加入合作社用户申请植保计划
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
                [self popCurrentViewControllerAfterDelay];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
//            NSLog(@"planted type =%@",type);
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
}

- (NSDictionary *)Paramstype:(NSString*)type
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = type;
    return params;
}

//查询字典
- (void)findSysDictByType:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/system/findSysDictByType";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
//                [SVProgressHUD showSuccessWithStatus:msg];
                self.cateArray =[plantmodel plantWithDataArray:data];
            }else{
//                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}



@end
