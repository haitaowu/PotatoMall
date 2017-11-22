//
//  UnionRemitController.m
//  PotatoMall
//合作社-添加成员-请求验证码界面
//  Created by taotao on 2017/10/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "UnionRemitController.h"
#import "SVProgressHUD.h"
#import "UnionRemitDetailController.h"

@interface UnionRemitController ()
@property (weak, nonatomic) IBOutlet UITextField *remitMoneyField;

@end

@implementation UnionRemitController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.remitMoneyField.layer.borderColor = RGBA(217, 217, 217, 0.8).CGColor;
    self.remitMoneyField.layer.borderWidth = 0.8;
    
    UIView *leftView = [[UIView alloc] init];
    CGFloat viewW = 10;
    CGFloat viewH = 50;
    CGRect leftF = CGRectMake(0, 0, viewW, viewH);
    leftView.frame = leftF;
    self.remitMoneyField.leftView = leftView;
    self.remitMoneyField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"remitDetailSegue"]) {
        UnionRemitDetailController *vc = segue.destinationViewController;
        vc.orderInfo = sender;
    }
//    }else if ([segue.identifier isEqualToString:@"waitValidSegue"]) {
//        WaitingMembersController *vc = segue.destinationViewController;
//        vc.unionId = self.unionId;
//    }
}
#pragma mark - private methods


#pragma mark - selectors
//确认充值
- (IBAction)tapConfirmRemitBtn:(UIButton*)sender{
    [self.view endEditing:YES];
    NSString *phoneTxt = self.remitMoneyField.text;
    if (phoneTxt.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入充值金额"];
        return;
    }
    NSDictionary *params = [self paramRemit];
    [self requestRemitWithParams:params];
}


#pragma mark - requset server
//请求汇款的参数
- (NSDictionary *)paramRemit
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *money = self.remitMoneyField.text;
    params[@"unionId"] = self.unionId;
    params[@"payPrice"] = money;
    //支付类型 15 线下汇款
    params[@"payType"] = @"15";
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    params[kUserIdKey] = model.userId;
    return params;
}

//请求汇款接口
- (void)requestRemitWithParams:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        [SVProgressHUD show];
        NSString *subUrl = @"pay/createUnionRemitRechargeOrder";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
                NSString *obj = [dict valueForKey:@"obj"];
                if (obj != nil) {
                    [SVProgressHUD dismiss];
                    [self performSegueWithIdentifier:@"remitDetailSegue" sender:obj];
//                    [self.navigationController popViewControllerAnimated:YES];
                }else{
//                    [SVProgressHUD showErrorWithStatus:@"验证失败"];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}


#pragma mark - UIScorllView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}

#pragma mark - UITableView --- Table view  delegate
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 16;
//}

@end
