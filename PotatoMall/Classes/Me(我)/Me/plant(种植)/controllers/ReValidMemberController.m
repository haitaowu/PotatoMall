//
//  ReValidMemberController.m
//  PotatoMall
//
//  Created by taotao on 2017/10/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "ReValidMemberController.h"
#import "SVProgressHUD.h"
#import "plantmodel.h"


@interface ReValidMemberController ()
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;


@property (nonatomic,assign) int  countNum;
@property (nonatomic,strong)NSTimer *countTimer;


@end

@implementation ReValidMemberController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateLabel.text = self.model.createDate;
    self.phoneLabel.text = self.model.phone;
    
    self.codeField.layer.borderColor = RGBA(217, 217, 217, 0.8).CGColor;
    self.codeField.layer.borderWidth = 0.8;
    
    UIView *leftView = [[UIView alloc] init];
    CGFloat viewW = 10;
    CGFloat viewH = 50;
    CGRect leftF = CGRectMake(0, 0, viewW, viewH);
    leftView.frame = leftF;
    self.codeField.leftView = leftView;
    self.codeField.leftViewMode = UITextFieldViewModeAlways;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.countTimer invalidate];
    self.countTimer = nil;
}

#pragma mark - private methods
- (void)cuntingDown
{
    [self updateCodeBtnUIWith:NO];
    self.countNum = 60;
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCodeBtn) userInfo:nil repeats:YES];
}


- (void)updateCodeBtn
{
    self.countNum = self.countNum - 1;
    if (self.countNum == 0) {
        [self.countTimer invalidate];
        self.countTimer = nil;
        [self updateCodeBtnUIWith:YES];
    }else{
        NSString *countTxt = [NSString stringWithFormat:@"%dS重发验证码",self.countNum];
        [self.sendCodeBtn setTitle:countTxt forState:UIControlStateNormal];
    }
}

- (void)updateCodeBtnUIWith:(BOOL)enable
{
    self.sendCodeBtn.enabled = enable;
    if (enable) {
//        [self.sendCodeBtn setBackgroundColor:kMainNavigationBarColor];
        [self.sendCodeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
//        self.sendCodeBtn.titleLabel.textColor = [UIColor whiteColor];
    }else{
//        [self.sendCodeBtn setBackgroundColor:[UIColor grayColor]];
        [self.sendCodeBtn setTitle:@"60S重发验证码" forState:UIControlStateNormal];
//        self.sendCodeBtn.titleLabel.textColor = [UIColor lightGrayColor];
    }
}


#pragma mark - selectors
//点击请求验证码
- (IBAction)tapReqValidateCodeBtn:(UIButton*)sender{
    [self reqValidateCode];
}

//提交验证
- (IBAction)tapSubmitCodeBtn:(UIButton*)sender{
    NSString *codeStr = self.codeField.text;
    if (codeStr.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"输入验证码"];
        return;
    }
    [self.view endEditing:YES];
    NSString *phone = self.model.phone;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:phone,kPhone,codeStr,kVerfiyCode,nil];
    [self requestValidateCodeWithParams:params];
}

#pragma mark - requset server
//请求验证码
- (void)reqValidateCode
{
    NSString *phoneTxt = self.model.phone;
    [SVProgressHUD showWithStatus:@"请求验证码"];
    NSString *subUrl = @"user/getCheckCode";
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:phoneTxt,kPhone,@"3",kReqType,nil];
    [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id list) {
        [self cuntingDown];
        if (status == StatusTypSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"请求验证码成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求验证码失败"];
        }
    } reqFail:^(int type, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        [self cuntingDown];
    }];
}

//验证验证码
- (void)requestValidateCodeWithParams:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        [SVProgressHUD showWithStatus:@"验证验证码"];
        NSString *subUrl = @"user/checkVerfiyCode";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
                NSString *obj = [dict strValueForKey:@"obj"];
                if ([obj isEqualToString:@"true"]) {
                    [SVProgressHUD dismiss];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"验证失败"];
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
