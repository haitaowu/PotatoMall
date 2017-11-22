//
//  UnionRemitDetailController.m
//  PotatoMall
//  Created by taotao on 2017/10/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "UnionRemitDetailController.h"
#import "SVProgressHUD.h"



@interface UnionRemitDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *verifyCodeLabel;

@end

@implementation UnionRemitDetailController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.orderInfo != nil) {
        [self updateUI];
    }
}

#pragma mark - private methods
- (void)updateUI
{
    NSString *orderId = [self.orderInfo strValueForKey:@"orderId"];
    if ((orderId != nil) && (orderId.length > 0)) {
        [self showAlertViewForUnCompletionOrder];
    }
    
    NSString *payPrice = [self.orderInfo strValueForKey:@"payPrice"];
    self.payPriceLabel.text = payPrice;
    
    NSString *bankCardNo = [self.orderInfo strValueForKey:@"bankCardNo"];
    self.bankCardNoLabel.text = bankCardNo;
    
    NSString *bankName = [self.orderInfo strValueForKey:@"bankName"];
    self.bankNameLabel.text = bankName;
    
    NSString *accountName = [self.orderInfo strValueForKey:@"accountName"];
    self.accountNameLabel.text = accountName;
    
    NSString *verifyCode = [self.orderInfo strValueForKey:@"verifyCode"];
    self.verifyCodeLabel.text = verifyCode;
}

- (void)showAlertViewForUnCompletionOrder
{
    NSString *title = @"注意";
    NSString *message = @"您还有一条没有完成的银行汇款充值申请，请尽快完成此次银行汇款，以便再次充值；如果你已汇款，请耐心等待后台运营人员处理";
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    UIAlertAction * checkAction = [UIAlertAction actionWithTitle:@"查看充值信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:checkAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - selectors
//确认充值
- (IBAction)tapSendMsgBtn:(UIButton*)sender{
    
    NSDictionary *params = [self paramSendMsg];
    [self requestSendMsgWithParams:params];
}

#pragma mark - requset server
//请求发送到手机的参数
- (NSDictionary *)paramSendMsg
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *orderId = [self.orderInfo strValueForKey:@"orderId"];
    params[@"orderId"] = orderId;
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    params[@"phone"] = model.phone;
    return params;
}

//请求发送到手机接口请求
- (void)requestSendMsgWithParams:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        [SVProgressHUD show];
        NSString *subUrl = @"pay/sendUnionRemitRechargeMessage";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
                NSString *obj = [dict strValueForKey:@"obj"];
                if ([obj isEqualToString:@"1"]) {
                    [SVProgressHUD showSuccessWithStatus:msg];
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



@end
