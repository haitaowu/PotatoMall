//
//  plantlistViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "plantlistViewController.h"

@interface plantlistViewController ()

@end

@implementation plantlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCateGoryView];
    self.title=@"联合体订单";
    
    NSDictionary *listParams=[self listParams];
    [self list:listParams];
    
    _mtableview.tableFooterView = [[UIView alloc]init];
    // Do any additional setup after loading the view from its nib.
}



- (void)list:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        
    }else{
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/order/list";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
//                mlistdata=[plantmodel plantWithDataArray:data];
//
//                self.numlabel0.text=[NSString stringWithFormat:@"(共%lu名)",[mlistdata count]];
//
//                [_mtableview reloadData];
//
                
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
    
}

- (NSDictionary *)listParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"type"] = @"1";
    return params;
}


- (void)setupCateGoryView
{
    
    self.topview.titles = [NSMutableArray arrayWithObjects:@"全部",@"待提货",@"已完成",nil];
    [self.topview showSeparatorLine];
    [self.topview scrollVisibleTo:0];
    self.topview.normalTextColor = kMainTitleBlackColor;
    self.topview.selectedTextColor = kMainNavigationBarColor;
    self.topview.sliderColor = kMainNavigationBarColor;
    self.topview.sliderWidthPercent = 0.8;
    
    self.topview.selectedItemTitleBlock = ^(NSInteger idx ,NSString *title){
        NSDictionary *listParams=[self listParams];
        if (idx == 0) {
            [self list:listParams];
        }
        if (idx == 1) {
            [self list:listParams];
        }
        if (idx == 2) {
            [self list:listParams];
        }
        
    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
