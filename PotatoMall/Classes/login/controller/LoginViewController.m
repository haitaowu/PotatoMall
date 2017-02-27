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
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:kMainNavigationBarColor]];
    [self.tableView setBackgroundView:bgImgView];
    // right UIBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(tapRegistger)];
    
    //password textfield rightview
    _rightImage =[UIImage imageNamed:@"eye_close.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(closeEye:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:_rightImage forState:UIControlStateNormal];
//    UIImageView *rightView = [[UIImageView alloc] init];
    CGRect rightFrame = CGRectMake(0, 0, 20, 20);
    rightBtn.frame = rightFrame;
    _pwdTextField.rightView = rightBtn;
    _pwdTextField.rightViewMode = UITextFieldViewModeAlways;
    
    
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

#pragma mark -  IBaction  selectors methods
- (void)tapRegistger
{
    [self performSegueWithIdentifier:@"register" sender:nil];
}

- (void)closeEye:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    if (button.selected) {
        self.pwdTextField.secureTextEntry = NO;
        _rightImage = [UIImage imageNamed:@"eye_open.png"];
        [button setImage:_rightImage forState:UIControlStateSelected];
        
    } else {
        self.pwdTextField.secureTextEntry = YES;
        _rightImage = [UIImage imageNamed:@"eye_close.png"];
        [button setImage:_rightImage forState:UIControlStateNormal];
    }
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
