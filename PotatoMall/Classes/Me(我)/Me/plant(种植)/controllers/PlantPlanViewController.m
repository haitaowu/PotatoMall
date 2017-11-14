//
//  PlantPlanViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlantPlanViewController.h"
#import "PlantListTableViewCell.h"
#import "plantmodel.h"
#import "PlanWebViewViewController.h"

@interface PlantPlanViewController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@end

@implementation PlantPlanViewController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"合作社植保计划";
//    [self.mtableview setHidden:YES];
    _mtableview.emptyDataSetSource = self;
    _mtableview.emptyDataSetDelegate = self;
     [_mtableview registerNib:[UINib nibWithNibName:@"PlantListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listIdentifier"];
    [self reqUserUnionInformation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

/**
 * findUnionUserByUserId
 *createDate = "2017-11-02 07:41:36";
 headPic = "http://123.56.190.116:1000/upload/2017-10-22/84aeb6425c3d42b9b0b798f5a1527b74.png";
 phone = 18844038491;
 score = 0;
 uid = 224;
 unionId = 94;
 unionType = 1;
 userId = 2405;
 userName = "\U798f\U5927\U7237";
 userType = 1;
 verifyStatu = 2;
 */


#pragma mark - private methods
- (void)showOptionViewWithModel:(plantmodel*)model{
    
    PlanWebViewViewController *_PlanWebViewViewController = [[PlanWebViewViewController alloc] init];
    _PlanWebViewViewController.murl = model.helpUrl;
    [self.navigationController pushViewController:_PlanWebViewViewController animated:YES];
}

- (void)reqUserUnionInformation
{
    //
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    __block typeof(self) blockSelf = self;
    [self reqUserUnionInfoWith:params resultBlock:^(id data) {
        if (data != nil) {
            NSDictionary *params=[blockSelf findUserPlatRecordWithDict:data];
            [blockSelf findUserPlatRecord:params];
        }
    }];
}

- (NSDictionary *)findUserPlatRecordWithDict:(NSDictionary*)dict
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = [dict strValueForKey:@"unionId"];
    params[@"type"] =  [dict strValueForKey:@"userType"];
    return params;
}


#pragma mark - requset server
- (void)reqUserUnionInfoWith:(NSDictionary*)params resultBlock:(void(^)(id data))resultBlock
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"user_union/findUnionUserByUserId";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD dismiss];
                NSDictionary *dataDict = [DataUtil dictionaryWithJsonStr:data];
                NSDictionary *obj = dataDict[@"obj"];
                NSLog(@"obj = %@ data = %@",obj,dataDict);
                if (obj != nil){
                    resultBlock(obj);
                }
                    
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
    
}
//查询用户植保记录
- (void)findUserPlatRecord:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"plat/findUserPlatRecord";
//        NSString *subUrl = @"/user_union/findUnionUserByUserId";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
                mlistdata=[plantmodel plantWithDataArray1:data];
//                [self.mtableview setHidden:NO];
                [self.mtableview reloadData];
//                if([mlistdata count]==0){
//                    [self.infoview setHidden:NO];
//                }
            }else{
                mlistdata = [NSMutableArray array];
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            mlistdata = [NSMutableArray array];
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
    
}

#pragma mark - selectors
- (IBAction)typebuttonlick:(id)sender {
    [SVProgressHUD showErrorWithStatus:@"您没有管理员权限,无法操作"];
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
    return 50;
}

#pragma mark - UITableView --- Table view  datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mlistdata count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString  *listCellID = @"listIdentifier";
    PlantListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    plantmodel *model=[mlistdata objectAtIndex:indexPath.row];
    cell.model = model;
    __block typeof(self) blockSelf = self;
    cell.optBlock = ^(plantmodel *model) {
        [blockSelf showOptionViewWithModel:model];
    };
//    cell.title.text=model.content;
//    cell.content.text=model.catalogName;
//    murl=model.helpUrl;
//    [cell.cellclickbutton addTarget:self action:@selector(cellclick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - DZNEmptyDataSetSource Methods
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -144;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if ([RequestUtil networkAvaliable] == NO) {
        NSString *text = @"咦！断网了";
        NSAttributedString *txt = [CommHelper emptyTitleWithTxt:text];
        return txt;
    }else if ((mlistdata != nil) && (mlistdata.count == 0)){
        [_mtableview.mj_footer setHidden:YES];
        NSString *text = @"暂无植保操作";
        NSAttributedString *txt = [CommHelper emptyTitleWithTxt:text];
        return txt;
    }else{
        return [[NSAttributedString alloc] init];
    }
}


@end
