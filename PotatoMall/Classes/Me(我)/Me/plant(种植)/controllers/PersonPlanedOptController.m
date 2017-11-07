//
//  PersonPlanedOptController.m
//  PotatoMall
//
//  Created by taotao on 2017/11/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PersonPlanedOptController.h"


@interface PersonPlanedOptController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak) IBOutlet UITableView *tableView;

@end

@implementation PersonPlanedOptController

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - private methods

//submit
- (void)submitPersonPlanApply
{
    NSDictionary *params = [self paramPlanted];
    [self reqPlantedPlanWith:params];
}

#pragma mark - selectors
- (IBAction)tapApplyBtn:(id)sender {
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
    

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PlantRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:PlantRecordCellID];
//    plantmodel *model = self.finishedRecords[indexPath.section];
//    cell.model = model;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELLLID"];
    return cell;
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
    params[@"planType"] = @"2";
    return params;
}

//个人申请植保计划
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
