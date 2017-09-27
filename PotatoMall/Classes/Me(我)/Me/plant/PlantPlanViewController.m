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

@interface PlantPlanViewController ()

@end

@implementation PlantPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"合作社植保计划";
    [self.mtableview setHidden:YES];
     [_mtableview registerNib:[UINib nibWithNibName:@"PlantListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listIdentifier"];
    NSDictionary *findUserPlatRecordParams=[self findUserPlatRecordParams];
    //    NSLog(@"findUserPlatRecordParams==%@",findUserPlatRecordParams);
    [self findUserPlatRecord:findUserPlatRecordParams];
    
    
    
    // Do any additional setup after loading the view.
}


- (void)findUserPlatRecord:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        
    }else{
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/plat/findUserPlatRecord";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
                mlistdata=[plantmodel plantWithDataArray1:data];
                [self.mtableview setHidden:NO];
                [self.mtableview reloadData];
                
                if([mlistdata count]==0){
                    [self.infoview setHidden:NO];
                    
                }
                //                NSLog(@"mlistdata==%@",mlistdata);
                
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
    
}
- (IBAction)typebuttonlick:(id)sender {
    [SVProgressHUD showErrorWithStatus:@"您没有管理员权限,无法操作"];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSDictionary *findUserPlatRecordParams=[self findUserPlatRecordParams];
    [self findUserPlatRecord:findUserPlatRecordParams];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mlistdata count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString  *listCellID = @"listIdentifier";
    PlantListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    plantmodel *model=[mlistdata objectAtIndex:indexPath.row];
    cell.title.text=model.content;
    cell.content.text=model.catalogName;
    murl=model.helpUrl;
    [cell.cellclickbutton addTarget:self action:@selector(cellclick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)cellclick:(UIButton *)sender{
    
    PlanWebViewViewController *_PlanWebViewViewController = [[PlanWebViewViewController alloc] init];
    _PlanWebViewViewController.murl = murl;
    [self.navigationController pushViewController:_PlanWebViewViewController animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
