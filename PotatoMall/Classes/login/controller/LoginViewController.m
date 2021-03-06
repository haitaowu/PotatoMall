//
//  MeTableController.m
//  MeiXun
//
//  Created by pactera on 5/3/16.
//  Copyright © 2016 taotao. All rights reserved.
//

#import "LoginViewController.h"
#import "MJExtension.h"
#import "StateRadiusBtn.h"
#import "NSString+Extentsion.h"

#define kSectionCount                           1
#define kSectionFirstIdx                        0
#define kRowsCountSectionFirst                  4

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet StateRadiusBtn *loginBtn;
@property (nonatomic,strong) UIImage *rightImage;
@end

@implementation LoginViewController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self updateUIWithUserState];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark - setup update ui
- (void)updateUIWithUserState
{
    if ([[UserModelUtil sharedInstance] userState] == NoCompleted) {
        [self performSegueWithIdentifier:@"idSegue" sender:nil];
    }
}

- (void)setupUI
{
    //password textfield rightview
    UIImage *accountImage =[UIImage imageNamed:@"login_account"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:accountImage forState:UIControlStateNormal];
//    UIImageView *rightView = [[UIImageView alloc] init];
    CGRect rightFrame = CGRectMake(0, 0, 30, 30);
    leftBtn.frame = rightFrame;
    _accountTextField.leftView = leftBtn;
    _accountTextField.leftViewMode = UITextFieldViewModeAlways;
    [_accountTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIImage *pwdImage =[UIImage imageNamed:@"login_lock"];
    UIButton *pwdLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pwdLeftBtn setImage:pwdImage forState:UIControlStateNormal];
    //    UIImageView *rightView = [[UIImageView alloc] init];
    CGRect pwLeftF = CGRectMake(0, 0, 30, 30);
    pwdLeftBtn.frame = pwLeftF;
    _pwdTextField.leftView = pwdLeftBtn;
    _pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [_pwdTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (![self.type isEqualToString:kPresentModal]) {
        UIView *view = [[UIView alloc] init];
        UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.leftBarButtonItems = @[leftBarItem];
    }

}
- (void)tapBackBtn
{
    if ([self.type isEqualToString:kPresentModal]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kGuestLoginSuccessNotification object:nil];
    }else{
//        [super tapBackBtn];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
    }
}

#pragma mark - private methods
- (void)updateRegistBtnEnableStatus
{
    NSString *accountStr = [self.accountTextField.text strWithoutSpace];;
    NSString *pwdStr = [self.pwdTextField.text strWithoutSpace];
    if ((accountStr.length > 0)&&(pwdStr.length > 0)) {
        self.loginBtn.enabled = YES;
    }else{
        self.loginBtn.enabled = NO;
    }
    
}

#pragma mark - selectors
- (void)textDidChange:(UITextField*)sender
{
    [self updateRegistBtnEnableStatus];
}

#pragma mark - UIScorllView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else{
        return 20;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    [self updateRegistBtnEnableStatus];
//    return YES;
//}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [self updateRegistBtnEnableStatus];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
}


#pragma mark - requset server
//点击登录
- (IBAction)tapLoginBtn:(id)sender {
    [self.tableView endEditing:YES];
    NSString *accountTxt = self.accountTextField.text;
    NSString *pwdTxt = self.pwdTextField.text;
    if (accountTxt.length <= 0) {
        [SVProgressHUD showErrorWithStatus:kAlertEnterAccountMsg];
        return;
    }else if (pwdTxt.length <= 0) {
        [SVProgressHUD showErrorWithStatus:kAlertEnterPasswordMsg];
        return;
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:accountTxt,kAccount,pwdTxt,kPassword, nil];
        NSString *subUrl = @"user/login";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            if (status == StatusTypSuccess) {
                NSDictionary *dataDict = [DataUtil dictionaryWithJsonStr:data];
                NSDictionary *modelDict = dataDict[@"obj"];
//                id user
                UserModel *model = [UserModel mj_objectWithKeyValues:modelDict];
                [[UserModelUtil sharedInstance] archiveUserModel:model];
                [UserModelUtil saveUser:accountTxt password:pwdTxt];
                [self tapBackBtn];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
    
}

@end
