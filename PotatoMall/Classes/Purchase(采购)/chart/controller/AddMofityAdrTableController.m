//
//  AddMofityAdrTableController.m
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "NSDictionary+Extension.h"
#import "AddMofityAdrTableController.h"

@interface AddMofityAdrTableController ()
@property (weak, nonatomic) IBOutlet UITextField *reciverField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *adrDetailField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;


@end

@implementation AddMofityAdrTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedAddress:) name:kSelectedCityNotification object:nil];
    [self.navigationController  setToolbarHidden:YES animated:NO];
    [self setupUI];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private methods
- (void)setupUI
{
    if (self.editType == ReviceAdrTypeModify) {
        self.reciverField.text = [self.adrInfo strValueForKey:@"addressName"];
        self.phoneField.text = [self.adrInfo strValueForKey:@"addressMoblie"];
        self.adrDetailField.text = [self.adrInfo strValueForKey:@"addressDetail"];
        NSString *addressProvinceName = [self.adrInfo strValueForKey:@"addressProvinceName"];
        NSString *addressCityName = [self.adrInfo strValueForKey:@"addressCityName"];
        NSString *addressCountyName = [self.adrInfo strValueForKey:@"addressCountyName"];
        NSString *cityStr = [NSString stringWithFormat:@"%@%@%@",addressProvinceName,addressCityName,addressCountyName];
        self.cityField.text = cityStr;
    }
}
#pragma mark - selectors
//确认完成
- (IBAction)tapConfirmBtn:(UIButton*)sender {
    HTLog(@"hello tapConfirmBtn ");
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSString *reciver = self.reciverField.text;
    NSString *phone = self.phoneField.text;
    NSString *adrDetail = self.adrDetailField.text;
    if (reciver.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入收货人"];
        return;
    }else if (phone.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入联系电话"];
        return;
    }else if (self.adrInfo == nil){
        [SVProgressHUD showInfoWithStatus:@"请选择城市"];
        return;
    }else if (adrDetail.length <= 0){
        [SVProgressHUD showInfoWithStatus:@"请输入详细地址"];
        return;
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"customerId"] = model.userId;
        params[@"addressName"] = reciver;
        params[@"addressProvince"] = [self.adrInfo objectForKey:@"infoProvince"];
        params[@"addressCity"] = [self.adrInfo objectForKey:@"infoCity"];
        params[@"addressCounty"] = [self.adrInfo objectForKey:@"infoCounty"];
        params[@"addressDetail"] = adrDetail;
        params[@"addressMoblie"] = phone;
//        params[@"addressZip"] = @"21400";
//        params[@"addressAlias"] = @"家里";
        if (self.editType == ReviceAdrTypeAdd) {
            params[@"isDefault"] = @"1";
        }else{
            params[@"isDefault"] = @"0";
        }
        [self reqModifyAdrWithParams:params];
    }
}

//选择城市
- (IBAction)tapChoiceCityBtn:(UIButton*)sender {
    HTLog(@"hello tapChoiceCityBtn ");
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *control = [storyBoard instantiateViewControllerWithIdentifier:@"ProviceTableController"];
    [self.navigationController pushViewController:control animated:YES];
}

//选择城市后的通知
- (void)selectedAddress:(NSNotification*)sender
{
    NSString *adr = sender.object;
    self.cityField.text = adr;
    [UserModelUtil sharedInstance].userModel.address = adr;
    NSDictionary *userInfo = sender.userInfo;
    self.adrInfo = [userInfo objectForKey:@"adr"];
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - requset server
- (void)reqModifyAdrWithParams:(NSDictionary*)params
{
    NSString *subUrl = @"address/saveOrUpdateUserAddress";
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
    [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
        if (status == StatusTypSuccess) {
            [SVProgressHUD showSuccessWithStatus:msg];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } reqFail:^(int type, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}
#pragma mark - UITableView --- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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



@end
