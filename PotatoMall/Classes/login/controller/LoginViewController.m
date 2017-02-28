//
//  MeTableController.m
//  MeiXun
//
//  Created by pactera on 5/3/16.
//  Copyright © 2016 taotao. All rights reserved.
//

#import "LoginViewController.h"
#import "MJExtension.h"
#import "UIImage+Color.h"

#define kSectionCount                           1
#define kSectionFirstIdx                        0
#define kRowsCountSectionFirst                  4

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (nonatomic,strong) UIImage *rightImage;
@end

@implementation LoginViewController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
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
    
    UIImage *pwdImage =[UIImage imageNamed:@"login_lock"];
    UIButton *pwdLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pwdLeftBtn setImage:pwdImage forState:UIControlStateNormal];
    //    UIImageView *rightView = [[UIImageView alloc] init];
    CGRect pwLeftF = CGRectMake(0, 0, 30, 30);
    pwdLeftBtn.frame = pwLeftF;
    _pwdTextField.leftView = pwdLeftBtn;
    _pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIView *view = [[UIView alloc] init];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItems = @[leftBarItem];
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

#pragma mark - UIScorllView delegate 
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}


#pragma mark - requset server
//点击注册新用户
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
            [SVProgressHUD showWithStatus:msg];
            if (status == StatusTypSuccess) {
                NSString *dataStr = [DataUtil decryptStringWith:data];
//                id user
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
    
}

@end
