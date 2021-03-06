//
//  MeTableController.m
//  MeiXun
//
//  Created by pactera on 5/3/16.
//  Copyright © 2016 taotao. All rights reserved.
//

#import "RegisterController.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "StateRadiusBtn.h"
#import "NSString+Extentsion.h"
#import "HTTextField.h"
#import "UserModel.h"


#define kSectionCount                           1
#define kSectionFirstIdx                        0
#define kRowsCountSectionFirst                  4

#define kTableviewCellHeight                    44



@interface RegisterController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet HTTextField *phoneTextField;
//@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (nonatomic,weak)  IBOutlet UIButton *codeBtn;
@property (nonatomic,assign) int  countNum;
@property (nonatomic,strong)NSTimer *countTimer;
@property (nonatomic,strong) UIImage *rightImage;
@property (weak, nonatomic) IBOutlet StateRadiusBtn *registerBtn;

@end

@implementation RegisterController
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

#pragma mark - setup UI 
- (void)setupUI
{
    [_codeTextField addTarget:self action:@selector(textStrDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_phoneTextField addTarget:self action:@selector(textStrDidChange:) forControlEvents:UIControlEventEditingChanged];
    //password textfield rightview
    _rightImage =[UIImage imageNamed:@"uneye"];
    UIButton *pwdRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pwdRightBtn addTarget:self action:@selector(closeEye:) forControlEvents:UIControlEventTouchUpInside];
    [pwdRightBtn setImage:_rightImage forState:UIControlStateNormal];
    CGRect pwdRightF = CGRectMake(0, 0, 30, 30);
    pwdRightBtn.frame = pwdRightF;
    _pwdTextField.rightView = pwdRightBtn;
    _pwdTextField.rightViewMode = UITextFieldViewModeAlways;
    [_pwdTextField addTarget:self action:@selector(textStrDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)updateCodeBtnUIWith:(BOOL)enable
{
    self.codeBtn.enabled = enable;
    if (enable) {
        [self.codeBtn setBackgroundColor:kMainNavigationBarColor];
        [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.codeBtn.titleLabel.textColor = [UIColor whiteColor];
    }else{
        [self.codeBtn setBackgroundColor:[UIColor grayColor]];
        [self.codeBtn setTitle:@"60S" forState:UIControlStateNormal];
        self.codeBtn.titleLabel.textColor = [UIColor lightGrayColor];
    }
}

- (void)closeEye:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    if (button.selected) {
        self.pwdTextField.secureTextEntry = NO;
        _rightImage = [UIImage imageNamed:@"password-eye-r"];
        [button setImage:_rightImage forState:UIControlStateSelected];
        
    } else {
        self.pwdTextField.secureTextEntry = YES;
        _rightImage = [UIImage imageNamed:@"uneye"];
        [button setImage:_rightImage forState:UIControlStateNormal];
    }
}

#pragma mark - selectors
- (void)textStrDidChange:(UITextField*)sender
{
    [self updateRegistBtnEnableStatus];
}


#pragma mark - UITableView ---  Table view data source
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

#pragma mark - private methods
- (void)updateRegistBtnEnableStatus
{
    NSString *accountStr = [self.phoneTextField.text strWithoutSpace];;
    NSString *pwdStr = [self.pwdTextField.text strWithoutSpace];
    NSString *codeStr = [self.codeTextField.text strWithoutSpace];
    if ((accountStr.length > 0)&&(codeStr.length > 0)&&(pwdStr.length > 0)) {
        self.registerBtn.enabled = YES;
    }else{
        self.registerBtn.enabled = NO;
    }
}

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
        NSString *countTxt = [NSString stringWithFormat:@"%dS",self.countNum];
        [self.codeBtn setTitle:countTxt forState:UIControlStateNormal];
    }
}

- (BOOL)checkNickName:(NSString *)string
{
    NSInteger length = 0;
    for (int i=0; i<string.length; i++) {
        NSRange range=NSMakeRange(i,1);
        NSString *subString=[string substringWithRange:range];
        const char *cString=[subString UTF8String];
        if (strlen(cString)==3)
        {
            //            HTLog(@"昵称是汉字");
            length+=2;
            
        } else if(strlen(cString)==1)
        {
            //            HTLog(@"昵称是字母");
            length+=1;
        }
    }
    
    if (length >= 4 && length <= 30) {
        return YES;
    } else {
        return NO;
    }
}

- (NSMutableDictionary*)paramsByCurrentUser
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *pwdTxt = self.pwdTextField.text;
    NSString *phoneTxt = self.phoneTextField.text;
    NSString *codeTxt = self.codeTextField.text;
    params[kPhone] = phoneTxt;
    params[kPassword] = pwdTxt;
    params[kVerfiyCode] = codeTxt;
    return params;
}

- (BOOL)nickFormatValidateWith:(NSString*)nickName
{
    NSString *regex = @"[-_a-zA-Z0-9\u4e00-\u9fa5][-_a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:nickName];
}

#pragma mark - private methods
- (UserModel *)userModelWithData:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    id obj = [dict objectForKey:@"obj"];
    UserModel *userModel = [UserModel mj_objectWithKeyValues:obj];
    return userModel;
}

#pragma mark -  IBaction methods
- (void)tapBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)tapReaderSpecBtn:(id)sender {
}

- (IBAction)tapAgreeSpecBtn:(UIButton*)sender {
    sender.selected = !sender.selected;
}

//请求验证码
- (IBAction)requestRegisterCode
{
    NSString *phoneTxt = self.phoneTextField.text;
    if (![phoneTxt rightPhoneNumFormat]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    [SVProgressHUD showWithStatus:@"请求验证码"];
    NSString *subUrl = @"user/getCheckCode";
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:phoneTxt,kPhone,@"1",kReqType,nil];
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

- (IBAction)tapRegisterBtn:(id)sender {
    [self.view endEditing:YES];
    
    NSString *pwdTxt = self.pwdTextField.text;
    NSString *phoneTxt = self.phoneTextField.text;
    NSString *codeTxt = self.codeTextField.text;
    if (![phoneTxt rightPhoneNumFormat]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }else if(codeTxt.length <= 0){
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }else if(pwdTxt.length <= 0){
        [SVProgressHUD showErrorWithStatus:@"密码必须8-15位数字或英文"];
        return;
    }else if(pwdTxt.length < 8){
        [SVProgressHUD showErrorWithStatus:@"密码必须8-15位数字或英文"];
        return;
    }else if(pwdTxt.length > 15){
        [SVProgressHUD showErrorWithStatus:@"密码必须8-15位数字或英文"];
        return;
    }else if(self.agreeBtn.selected == NO){
        [SVProgressHUD showErrorWithStatus:@"同意本公司的协议才可以下一步哦"];
        return;
    }else{
        [self requestRegisterNewUser];
    }
}

#pragma mark - requset server
- (void)requestRegisterNewUser
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    NSString *subUrl = @"user/register";
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
    NSMutableDictionary *params = [self paramsByCurrentUser];
    [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
        [SVProgressHUD showSuccessWithStatus:msg];
        if (status == StatusTypSuccess) {
            UserModel *userModel = [self userModelWithData:data];
            [[UserModelUtil sharedInstance] archiveUserModel:userModel];
            [self performSegueWithIdentifier:@"selectIDSegue" sender:nil];
        }
    } reqFail:^(int type, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


@end
