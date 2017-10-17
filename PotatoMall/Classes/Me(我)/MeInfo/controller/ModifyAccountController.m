//
//  MeTableController.m
//  MeiXun
//
//  Created by pactera on 5/3/16.
//  Copyright © 2016 taotao. All rights reserved.
//

#import "ModifyAccountController.h"
#import "MJExtension.h"
#import "StateRadiusBtn.h"
#import "NSString+Extentsion.h"

#define kSectionCount                           1
#define kSectionFirstIdx                        0
#define kRowsCountSectionFirst                  4

@interface ModifyAccountController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet StateRadiusBtn *loginBtn;
@property (nonatomic,strong) UIImage *rightImage;
@end

@implementation ModifyAccountController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}



#pragma mark - setup update ui
- (void)updateUIWithUserState
{
}

- (void)setupUI
{
    //account textfield rightview
    UIImage *accountImage =[UIImage imageNamed:@"login_account"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:accountImage forState:UIControlStateNormal];
//    UIImageView *rightView = [[UIImageView alloc] init];
    CGRect rightFrame = CGRectMake(0, 0, 30, 30);
    leftBtn.frame = rightFrame;
    _accountTextField.leftView = leftBtn;
    _accountTextField.leftViewMode = UITextFieldViewModeAlways;
    [_accountTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - private methods
- (void)updateRegistBtnEnableStatus
{
    NSString *accountStr = [self.accountTextField.text strWithoutSpace];;
    if (accountStr.length > 0) {
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



#pragma mark - requset server
//点击修改手机号。
- (IBAction)tapLoginBtn:(id)sender {
    [self.tableView endEditing:YES];
    NSString *accountTxt = self.accountTextField.text;
    if([accountTxt rightPhoneNumFormat] == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确格式的手机号"];
        return;
    }
    if (accountTxt.length <= 0) {
        [SVProgressHUD showErrorWithStatus:kAlertEnterAccountMsg];
        return;
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:accountTxt,kPhone, nil];
        NSString *subUrl = @"user/updatePhone";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD showWithStatus:msg];
            if (status == StatusTypSuccess) {
                [UserModelUtil saveUserAccount:accountTxt];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
    
}

@end
