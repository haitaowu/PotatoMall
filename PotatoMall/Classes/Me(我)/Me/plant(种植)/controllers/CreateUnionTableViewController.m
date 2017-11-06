//
//  CreateUnionTableViewController.m
//  PotatoMall
//
//  Created by taotao on 2017/10/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "CreateUnionTableViewController.h"
#import "SVProgressHUD.h"


@interface CreateUnionTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *unionNameField;
@property (weak, nonatomic) IBOutlet UITextField *cityNameField;
@property (weak, nonatomic) IBOutlet UITextField *detailAdrField;
@property (weak, nonatomic) IBOutlet UITextField *areaField;
@property(nonatomic,strong) NSDictionary *adrInfo;

@end

@implementation CreateUnionTableViewController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedAddress:) name:kSelectedCityNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - selectors
//提交审核
- (IBAction)tapSubmitReqBtn:(UIButton*)sender{
    NSString *unionName = self.unionNameField.text;
    NSString *detailAdr = self.detailAdrField.text;
    NSString *areaStr = self.areaField.text;
    if (unionName.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"输入名称"];
        return;
    }else if(self.adrInfo == nil){
        [SVProgressHUD showInfoWithStatus:@"选择地址"];
        return;
    }else if(detailAdr.length <= 0){
        [SVProgressHUD showInfoWithStatus:@"输入详细地址"];
        return;
    }else if(areaStr.length <= 0){
        [SVProgressHUD showInfoWithStatus:@"输入种植面积"];
        return;
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"unionName"] = unionName;
        params[@"infoProvince"] = [self.adrInfo objectForKey:@"infoProvince"];
        params[@"infoCity"] = [self.adrInfo objectForKey:@"infoCity"];
        params[@"infoCounty"] = [self.adrInfo objectForKey:@"infoCounty"];
        params[@"infoAddress"] = detailAdr;
        params[@"applyArea"] = areaStr;
        params[@"checkStatus"] = @"1";
        UserModel *model = [UserModelUtil sharedInstance].userModel;
        params[@"belongUserId"] = model.userId;
        [self submitCreateUnionWith:params];
    }
    HTLog(@"tapSubmitReqBtn");
}

//所在地区选择
- (IBAction)tapLocBtn:(UIButton*)sender{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *control = [storyBoard instantiateViewControllerWithIdentifier:@"ProviceTableController"];
    [self.navigationController pushViewController:control animated:YES];
}

//选择地区的通知
- (void)selectedAddress:(NSNotification*)sender
{
    NSString *adr = sender.object;
    self.cityNameField.text = adr;
    [UserModelUtil sharedInstance].userModel.address = adr;
    NSDictionary *userInfo = sender.userInfo;
    self.adrInfo = [userInfo objectForKey:@"adr"];
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - requset server
- (void)submitCreateUnionWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        NSString *subUrl = @"user_union/saveOrUpdateUserUnion";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params attach:nil reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"创建联合体成功"];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            HTLog(@"error msg = %@",msg);
        }];
//
//        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
//            if (status == StatusTypSuccess) {
//                 [SVProgressHUD showSuccessWithStatus:@"创建联合体成功"];
//            }else{
//                [SVProgressHUD showErrorWithStatus:msg];
//            }
//        } reqFail:^(int type, NSString *msg) {
//            HTLog(@"error msg = %@",msg);
//        }];
    }
}

#pragma mark - UIScorllView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 16;
}

@end
