//
//  PlantViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/6.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlantViewController.h"
#import "plantmodel.h"
#import "PlantManageViewController.h"
//#import "PlantSettingViewController.h"
//#import "PlantSetting0ViewController.h"
//#import "PlanthandleViewController.h"
#import "NSDictionary+Extension.h"
#import "UnionedPlanOptStateController.h"
#import "UnionedPlanedRecordController.h"
#import "PersonPlanApplyOptController.h"
#import "JoinedPlanedOptionController.h"

@interface PlantViewController ()
@property (nonatomic,assign)BOOL isUnioned;
@property (nonatomic,assign)BOOL isAddedPlaned;
@property (nonatomic,copy)NSString *planState;
@property (nonatomic,copy)NSString *unionId;
@end

@implementation PlantViewController

#pragma mark - Overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的种植";
    _unionId=@"";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary *parama=[self whetherUserUnionParams];
    [self whetherUserUnion:parama];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"plantmanage"]) {
        PlantManageViewController *vc = segue.destinationViewController;
        vc.unionId =_unionId;
        vc.planState = self.planState;
//    }else if ([segue.identifier isEqualToString:@"planStateSegue"]) {
//        UnionedPlanOptStateController *vc = segue.destinationViewController;
//        vc.planState = self.planState;
    }else if ([segue.identifier isEqualToString:@"unionedPlanedSegue"]) {
        UnionedPlanedRecordController *vc = segue.destinationViewController;
        vc.unionId = self.unionId;
    }else if ([segue.identifier isEqualToString:@"personPlanApplySegue"]) {
        PersonPlanApplyOptController *vc = segue.destinationViewController;
        vc.planState = self.planState;
    }else if ([segue.identifier isEqualToString:@"platePlanedOptSegue"]) {
        JoinedPlanedOptionController *vc = segue.destinationViewController;
        vc.unionId = self.unionId;
    }
}

#pragma mark - Privates
- (NSDictionary *)whetherUserUnionParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    return params;
}

#pragma mark - selectors
//创建联合体种植体>
- (void)stateclick:(UIButton *)sender{
    [self performSegueWithIdentifier:@"creUnionSegue" sender:nil];
}

#pragma mark - requset server
- (void)whetherUserUnion:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/user_union/whetherUserUnion";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD dismiss];
            if (status == StatusTypSuccess) {
//                [SVProgressHUD showSuccessWithStatus:msg];
                data=[plantmodel plantWithData:data];
                NSString *unionID=[data strValueForKey:@"unionId"];
                self.unionId = unionID;
                NSString *statusStr = [data strValueForKey:@"status"];
                if([statusStr isEqualToString:@"5"]){
//                    selection0=YES;
                    self.isUnioned = NO;
                    [self.mstatebutton setTitle:@"创建联合体种正在审核中>>" forState:UIControlStateNormal];
                } else if([statusStr isEqualToString:@"4"]){
                    self.isUnioned = NO;
                } else if([statusStr isEqualToString:@"3"]){
                    self.isUnioned = NO;
//                    [self requestAddedPlanStateWithUnionId:unionID];
                }else if([statusStr isEqualToString:@"2"]){
                    self.isUnioned = YES;
//                    [self requestAddedPlanStateWithUnionId:unionID];
                }else if([statusStr isEqualToString:@"1"]){
                    self.isUnioned = NO;
                    [self.mstatebutton setTitle:@"创建申请审核中......>>" forState:UIControlStateNormal];

//                    [self requestAddedPlanStateWithUnionId:unionID];
                }else if([statusStr isEqualToString:@"0"]){
                    self.isUnioned = NO;
                    self.mstatebutton.tag=-1;
                    [self.mstatebutton setTitle:@"创建联合体种植体>>" forState:UIControlStateNormal];
                    [self.mstatebutton addTarget:self action:@selector(stateclick:) forControlEvents:UIControlEventTouchUpInside];
                }
                if(self.isUnioned == NO){
                    [self.tableView reloadData];
                }
                [self requestAddedPlanStateWithUnionId:unionID];
//                NSLog(@"msg==%@",data);
//                NSLog(@"msg==%@",[data objectForKey:@"message"]);
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

//检查用户是否加入植保
- (void)requestAddedPlanStateWithUnionId:(NSString*)unionId
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    if ((unionId != nil) && (unionId.length > 0)) {
        params[kUnionIDKey] = unionId;
    }
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    NSString *subUrl = @"/plat/whetherPlan";
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
    [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
        [SVProgressHUD dismiss];
        if (status == StatusTypSuccess) {
            /*0暂无模板 1正在审核 2审核通过 3 申请被驳回 4 该用户以个体户进行植保计划，无法加入联合体*/
//            [SVProgressHUD showSuccessWithStatus:msg];
            data=[plantmodel plantWithData:data];
            NSString *statusStr = [data strValueForKey:@"status"];
            if([statusStr isEqualToString:@"1"]){
                self.isAddedPlaned = NO;
            } else if([statusStr isEqualToString:@"2"]){
                self.isAddedPlaned = YES;
            }else{
                self.isAddedPlaned = NO;
            }
            self.planState = statusStr;
        }else{
            self.isAddedPlaned = NO;
        }
        [self.tableView reloadData];
    } reqFail:^(int type, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        self.isAddedPlaned = NO;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        if(self.isUnioned == YES){
//            if (self.isAddedPlaned == YES){
            return 0;
//            }else{
//                return 3;
//            }
        }else{
            if (self.isAddedPlaned == YES){
                return 0;
            }else{
                return 3;
            }
        }
    }else if(section==1){
        if(self.isUnioned == YES){
//            if (self.isAddedPlaned == YES){
                return 3;
//            }else{
//                return 0;
//            }
        }else{
            return 0;
//            if (self.isAddedPlaned == YES){
//                return 0;
//            }else{
//                return 0;
//            }
        }
    }else{
        if(self.isUnioned == YES){
            return 0;
        }else{
            if (self.isAddedPlaned == YES){
                return 2;
            }else{
                return 0;
            }
        }
    }
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
    if(indexPath.section==0){
        if(indexPath.row==0){
            return 149.5;
        }
        if(indexPath.row==1){
            return 44;
        }
        if(indexPath.row==2){
            return 44;
        }
    }
    if(indexPath.section==1){
        if(indexPath.row==0){
            NSLog(@"unionId==%@",_unionId);
            if(_unionId!=nil){
                return 44;
            }else{
                return 0;
            }
        }
        if(indexPath.row==1){
            return 44;
        }
        if(indexPath.row==2){
            return 44;
        }
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section==0){
        if (indexPath.row==1) {
//            PlantSettingViewController *_PlantSettingViewController = [[PlantSettingViewController alloc] init];
            //        _PlanWebViewViewController.murl = murl;
            //        _UnionedMembersController.unionId =self.unionId;
//            [self.navigationController pushViewController:_PlantSettingViewController animated:YES];
            [self performSegueWithIdentifier:@"personPlanApplySegue" sender:nil];
        }
        
        if (indexPath.row==2) {
            [self performSegueWithIdentifier:@"plantinfoidentifier" sender:nil];
        }
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
            if (self.isUnioned) {
                if (self.isAddedPlaned) {
                    NSLog(@"已经加入植保计划");
                    [self performSegueWithIdentifier:@"platePlanedOptSegue" sender:nil];
                }else{
                    [self performSegueWithIdentifier:@"hasNoPlanSegue" sender:nil];
                }
            }
        }else if (indexPath.row==1) {
            NSLog(@"message===%@",message);
            [self performSegueWithIdentifier:@"plantmanage" sender:nil];
        }else {
            [self performSegueWithIdentifier:@"plantinfoidentifier" sender:nil];
        }
    }else{
        if (indexPath.row==0) {
             if (self.isAddedPlaned) {
                 [self performSegueWithIdentifier:@"platePlanedOptSegue" sender:nil];
             }else{
                 [self performSegueWithIdentifier:@"personPlanApplySegue" sender:nil];
             }
//            PlantSettingViewController *_PlantSettingViewController = [[PlantSettingViewController alloc] init];
//            [self.navigationController pushViewController:_PlantSettingViewController animated:YES];
        }
        if (indexPath.row == 1) {
            [self performSegueWithIdentifier:@"plantinfoidentifier" sender:nil];
        }
    }
}


//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if(section==0){
//        if(selection0){
//            return 2;
//        }else{
//            return 0;
//        }
//    }
//
//    if(section==1){
//        if(selection0){
//            return 0;
//        }else{
//            return 2;
//        }
//    }
//    return 0;
//}


@end
