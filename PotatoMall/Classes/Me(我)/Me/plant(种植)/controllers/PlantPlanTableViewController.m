//
//  PlantPlanTableViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlantPlanTableViewController.h"
#import "PlantTimeTableViewCell.h"
#import "PlantListTableViewCell.h"
#import "plantmodel.h"
#import "PlantInfoControllerViewController.h"
@interface PlantPlanTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *mtableview;
@end

@implementation PlantPlanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_mtableview registerNib:[UINib nibWithNibName:@"PlantTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeIdentifier"];
    
    [_mtableview registerNib:[UINib nibWithNibName:@"PlantListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listIdentifier"];
    
    NSDictionary *findUserPlatRecordParams=[self findUserPlatRecordParams];
//    NSLog(@"findUserPlatRecordParams==%@",findUserPlatRecordParams);
    [self findUserPlatRecord:findUserPlatRecordParams];
}

- (void)findUserPlatRecord:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"plat/findUserPlatRecord";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
                mlistdata=[plantmodel plantWithDataArray1:data];
                [self.mtableview reloadData];
//                NSLog(@"mlistdata==%@",mlistdata);
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

- (NSDictionary *)findUserPlatRecordParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    params[@"type"] = @"1";
    return params;
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 1;
    }
    if(section==1){
        return 1;
    }
    if(section==2){
        return  1;
    }else{
        return 0;
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell0;
    
    if(indexPath.section==0){
        NSString  *ChartCellID = @"timeIdentifier";
        
        PlantTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChartCellID];
        cell.creattime.text=self.createDate;
        
        return cell;
        
        //        PlantTimeTableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:ChartCellID];
    }
    
    if(indexPath.section==1){
        cell0 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        return cell0;
    }
    
    if(indexPath.section==2){
        NSString  *listCellID = @"listIdentifier";
        PlantListTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
//        cell.creattime.text=self.createDate;
        
        return cell2;
    }
    
    return cell0;
}

@end
