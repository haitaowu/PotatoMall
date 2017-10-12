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
#import "PlantSettingViewController.h"
#import "PlantSetting0ViewController.h"
#import "PlanthandleViewController.h"
#import "NSDictionary+Extension.h"

@interface PlantViewController ()
@property (nonatomic,assign)BOOL isUnioned;
@property (nonatomic,assign)BOOL isAddedPlaned;
@end

@implementation PlantViewController

#pragma mark - Overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的种植";
    unionId=@"";
    NSDictionary *parama=[self whetherUserUnionParams];
    [self whetherUserUnion:parama];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"plantmanage"]) {
        PlantManageViewController *vc = segue.destinationViewController;
        vc.unionId =unionId;
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
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
                data=[plantmodel plantWithData:data];
                NSString *unionID=[data strValueForKey:@"unionId"];
                NSString *statusStr = [data strValueForKey:@"status"];
                if([statusStr isEqualToString:@"5"]){
//                    selection0=YES;
                    self.isUnioned = NO;
                    [self.mstatebutton setTitle:@"创建联合体种正在审核中>>" forState:UIControlStateNormal];
                } else if([statusStr isEqualToString:@"4"]){
                    self.isUnioned = NO;
                    [self requestAddedPlanStateWithUnionId:unionID];
                } else if([statusStr isEqualToString:@"3"]){
                    self.isUnioned = NO;
                    [self requestAddedPlanStateWithUnionId:unionID];
                }else if([statusStr isEqualToString:@"2"]){
                    self.isUnioned = YES;
                    [self requestAddedPlanStateWithUnionId:unionID];
                }else if([statusStr isEqualToString:@"1"]){
                    self.isUnioned = NO;
                    [self.mstatebutton setTitle:@"创建申请审核中......>>" forState:UIControlStateNormal];
                    
                    
                    [self requestAddedPlanStateWithUnionId:unionID];
                }else if([statusStr isEqualToString:@"0"]){
                    self.isUnioned = NO;
                    self.mstatebutton.tag=-1;
                    [self.mstatebutton setTitle:@"创建联合体种植体>>" forState:UIControlStateNormal];
                    [self.mstatebutton addTarget:self action:@selector(stateclick:) forControlEvents:UIControlEventTouchUpInside];
                }
                
//                if ([data objectForKey:@"unionId"]) {
//                    NSLog(@"字典包含key:name");
//                    unionId=[data objectForKey:@"unionId"];
//                    selection0=NO;
//                }else{
//                    unionId=@"";
//                    NSLog(@"字典不包含key:name");
//                }
//
//                message=[data objectForKey:@"message"];
//                if([[data objectForKey:@"message"] isEqualToString:@"审核通过"]){
//                    unionId=[data objectForKey:@"unionId"];
//                    selection0=NO;
//                }
                
                if(self.isUnioned == NO){
                    [self.tableView reloadData];
                }
//                NSLog(@"selection0==%d",selection0);
                NSLog(@"msg==%@",data);
                NSLog(@"msg==%@",[data objectForKey:@"message"]);
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
    params[kUnionIDKey] = unionId;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    NSString *subUrl = @"/plat/whetherPlan";
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
    [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
        if (status == StatusTypSuccess) {
            [SVProgressHUD showSuccessWithStatus:msg];
            data=[plantmodel plantWithData:data];
            NSString *statusStr = [data strValueForKey:@"status"];
            if([statusStr isEqualToString:@"1"]){
                self.isAddedPlaned = YES;
            } else if([statusStr isEqualToString:@"2"]){
                self.isAddedPlaned = YES;
            }else{
                self.isAddedPlaned = NO;
            }
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
            if (self.isAddedPlaned == YES){
               return 0;
            }else{
                return 3;
            }
        }else{
            if (self.isAddedPlaned == YES){
                return 0;
            }else{
                return 3;
            }
        }
    }else if(section==1){
        if(self.isUnioned == YES){
            if (self.isAddedPlaned == YES){
                return 3;
            }else{
                return 0;
            }
        }else{
            if (self.isAddedPlaned == YES){
                return 3;
            }else{
                return 0;
            }
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
            NSLog(@"unionId==%@",unionId);
            if(unionId!=nil){
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
            PlantSetting0ViewController *_PlantSetting0ViewController = [[PlantSetting0ViewController alloc] init];
            //        _PlanWebViewViewController.murl = murl;
            //        _PlantUserViewController.unionId =self.unionId;
            [self.navigationController pushViewController:_PlantSetting0ViewController animated:YES];
        }
        
        if (indexPath.row==2) {
            [self performSegueWithIdentifier:@"plantinfoidentifier" sender:nil];
        }
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
            PlantSettingViewController *_PlantSettingViewController = [[PlantSettingViewController alloc] init];
            //        _PlanWebViewViewController.murl = murl;
            //        _PlantUserViewController.unionId =self.unionId;
            [self.navigationController pushViewController:_PlantSettingViewController animated:YES];
        }
        if (indexPath.row==1) {
            NSLog(@"message===%@",message);
            if([message isEqualToString:@"审核通过"]){
                [self performSegueWithIdentifier:@"plantmanage" sender:nil];
            }else{
                PlanthandleViewController *_PlanthandleViewController= [[PlanthandleViewController alloc] init];
                //        _PlanWebViewViewController.murl = murl;
                _PlanthandleViewController.unionId =unionId;
                [self.navigationController pushViewController:_PlanthandleViewController animated:YES];
            }
        }
        if (indexPath.row==2) {
            [self performSegueWithIdentifier:@"plantinfoidentifier" sender:nil];
        }
    }else{
        if (indexPath.row==0) {
            PlantSettingViewController *_PlantSettingViewController = [[PlantSettingViewController alloc] init];
            [self.navigationController pushViewController:_PlantSettingViewController animated:YES];
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
