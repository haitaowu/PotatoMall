//
//  PlantManageViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/9.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlantManageViewController.h"
#import "plantmodel.h"
#import "PlantPlanTableViewController.h"
#import "PlantInfoControllerViewController.h"
#import "PlantUserViewController.h"
#import "plantlistViewController.h"
#import "plantlistViewController.h"
#import "PlantInfomationTableViewController.h"
#import "UnionedPlanApplyController.h"
#import "UnionedPlanOptStateController.h"


@interface PlantManageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mtableview;

@end

@implementation PlantManageViewController
#pragma mark - Overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"合作社管理";
    tabledata=[[NSMutableArray alloc]initWithObjects:@"合作社植保计划",@"合作社信息",@"合作社成员",@"合作社订单", nil];
    
    NSDictionary *parama=[self detailUserUnionaParams];
    [self detailUserUnion:parama];
    
    NSDictionary *findWalletDetailParams=[self findWalletDetailParams];
    [self findWalletDetail:findWalletDetailParams];
    
    self.mtableview.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [self.navigationController  setToolbarHidden:YES animated:YES];
    [self.navigationController.toolbar setBackgroundColor:[UIColor whiteColor]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"plantplan"]) {
        PlantPlanTableViewController *vc = segue.destinationViewController;
        vc.unionId =self.unionId;
        vc.createDate=time;
    }else if ([segue.identifier isEqualToString:@"planinfo"]) {
        PlantInfoControllerViewController *vc = segue.destinationViewController;
        vc.canclick=@"1";
    }else if ([segue.identifier isEqualToString:@"plantinfomation"]) {
        PlantInfomationTableViewController *vc = segue.destinationViewController;
        vc.unionId =self.unionId;
    }else if ([segue.identifier isEqualToString:@"unionedPlanApplySegue"]) {
        UnionedPlanApplyController *vc = segue.destinationViewController;
        vc.unionId =self.unionId;
//    }else if ([segue.identifier isEqualToString:@"planReviewSegue"]) {
//        UnionedPlanOptStateController *vc = segue.destinationViewController;
//        vc.unionId = self.unionId;
//        vc.planState = self.planState;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Privates
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

#pragma mark - requset server
- (void)findWalletDetail:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/wallet/findWalletDetail";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
                data=[plantmodel plantWithData:data];
                [self.mdetail setText:[NSString stringWithFormat:@"联合体余额：%@",[data objectForKey:@"availableBalance"]]];
//                NSLog(@"findWalletDetail==%@",data);
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

- (void)detailUserUnion:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/user_union/detailUserUnion";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
                data=[plantmodel plantWithData:data];
                [self.mtitle setText:[data objectForKey:@"unionName"]];
                time=[data objectForKey:@"createDate"];
                NSLog(@"msg==%@",data);
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

- (NSDictionary *)detailUserUnionaParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    return params;
}

- (NSDictionary *)findWalletDetailParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    params[@"type"] = @"1";
    return params;
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tabledata count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIndetifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    cell.textLabel.text = [tabledata objectAtIndex:indexPath.row];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    return cell;
    
}

#pragma mark - UITableView --- Table view  delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
/*0暂无模板 1正在审核 2审核通过 3 申请被驳回 4 该用户以个体户进行植保计划，无法加入联合体*/
        if ([self.planState isEqualToString:@"1"]) {
            [self performSegueWithIdentifier:@"planReviewSegue" sender:nil];
        }else if ([self.planState isEqualToString:@"2"]) {
            [self performSegueWithIdentifier:@"plantplan" sender:nil];
        }else{
            [self performSegueWithIdentifier:@"unionedPlanApplySegue" sender:nil];
        }
    }
    if (indexPath.row==1) {
        [self performSegueWithIdentifier:@"plantinfomation" sender:nil];
    }
    
    if (indexPath.row==2) {
        PlantUserViewController *_PlantUserViewController = [[PlantUserViewController alloc] init];
//        _PlanWebViewViewController.murl = murl;
        _PlantUserViewController.unionId =self.unionId;
        [self.navigationController pushViewController:_PlantUserViewController animated:YES];
    }
    
    if (indexPath.row==3) {
        plantlistViewController *_plantlistViewController = [[plantlistViewController alloc] init];
        _plantlistViewController.unionId = self.unionId;
        [self.navigationController pushViewController:_plantlistViewController animated:YES];
    }
}



 

@end
