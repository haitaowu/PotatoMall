//
//暂时不用。 
//  
//
//  Created by pactera on 5/3/16.
//  Copyright © 2016 taotao. All rights reserved.

//

#import "ModifyPwdController.h"
#import "SVProgressHUD.h"
#import "NSString+Extentsion.h"
#import "RegisterSuccessController.h"



#define kSectionCount                           1
#define kSectionFirstIdx                        0
#define kRowsCountSectionFirst                  3



@interface ModifyPwdController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdNewTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdAginTextField;
@property (weak, nonatomic) IBOutlet UIButton *finishedBtn;
@end

@implementation ModifyPwdController

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
    [SVProgressHUD dismiss];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"successSegue"]) {
        RegisterSuccessController *destinationControl = (RegisterSuccessController*)segue.destinationViewController;
        destinationControl.desTitle = @"修改登录密码成功！";
        destinationControl.title = @"修改登录密码";
    }
}

#pragma mark - setup UI 
- (void)setupUI
{
    [_pwdNewTextField addTarget:self action:@selector(txtDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_pwdAginTextField addTarget:self action:@selector(txtDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - private methods
- (void)updateRegistBtnEnableStatus
{
    NSString *pwdStr = [self.pwdNewTextField.text strWithoutSpace];
    NSString *pwdAgainStr = [self.pwdAginTextField.text strWithoutSpace];;
    if ((pwdAgainStr.length > 0)&&(pwdStr.length > 0)) {
        self.finishedBtn.enabled = YES;
    }else{
        self.finishedBtn.enabled = NO;
    }
}

#pragma mark - selectors
- (void)txtDidChange:(UITextField*)sender
{
    [self updateRegistBtnEnableStatus];
}

#pragma mark - UITableView ---  Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kRowsCountSectionFirst;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSectionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

#pragma mark - UITableView --- Table view  delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScorllView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}


#pragma mark -  IBaction methods
- (IBAction)tapModifyPwdBtn:(id)sender {
    [self.view endEditing:YES];
    NSString *pwdTxt = self.pwdNewTextField.text;
    NSString *pwdAginTxt = self.pwdAginTextField.text;
    if (pwdTxt.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }else if(pwdAginTxt.length <= 0){
        [SVProgressHUD showErrorWithStatus:@"请再次输入密码"];
        return;
    }else if(![pwdAginTxt isEqualToString:pwdTxt]){
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
        return;
    }else{
        [self submitToModiftyUserPwdWithPwd:pwdTxt];
    }
}

#pragma mark - requset server
- (void)submitToModiftyUserPwdWithPwd:(NSString*)pwdTxt
{
    NSString *subUrl = @"user/updatePassword";
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kPassword] = pwdTxt;
    params[kUserIdKey] = [UserModelUtil sharedInstance].userModel.userId;
    [SVProgressHUD showWithStatus:@"修改密码中..."];
    [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
        if (status == StatusTypSuccess) {
            [SVProgressHUD showSuccessWithStatus:msg];
            id obj = [DataUtil dictionaryWithJsonStr:data];
            [UserModelUtil saveUserpassword:pwdTxt];
            id result = [obj objectForKey:@"obj"];
            if ([result isEqualToString:@"true"]) {
                
//                [self performSegueWithIdentifier:@"successSegue" sender:nil];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } reqFail:^(int type, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


@end
