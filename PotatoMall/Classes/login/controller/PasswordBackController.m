//
//  MeTableController.m
//  MeiXun
//
//  Created by pactera on 5/3/16.
//  Copyright © 2016 taotao. All rights reserved.
//

#import "PasswordBackController.h"
#import "SVProgressHUD.h"
#import "RadiusButton.h"
#import "PwdBackController.h"
#import "NSString+Extentsion.h"


#define kSectionCount                           1
#define kSectionFirstIdx                        0
#define kRowsCountSectionFirst                  3

#define kTableviewCellHeight                    50



@interface PasswordBackController ()
@property (nonatomic,strong)NSNumber *verifyCode;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (nonatomic,weak)   UIButton *codeBtn;
@property (nonatomic,strong)NSTimer *countTimer;
@property (nonatomic,assign) int  countNum;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end


@implementation PasswordBackController
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
    [SVProgressHUD dismiss];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pwdbackSegue"]) {
        PwdBackController *registerController = (PwdBackController*)segue.destinationViewController;
        registerController.params = sender;
    }
}

#pragma mark - upate ui
- (void)setupUI
{
    //code  textfield rightview
    RadiusButton *rightBtn = [RadiusButton buttonWithType:UIButtonTypeCustom];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.codeBtn = rightBtn;
    [rightBtn addTarget:self action:@selector(requestRegisterCode) forControlEvents:UIControlEventTouchUpInside];
    [self updateCodeBtnUIWith:YES];
    CGFloat heightPercent = 0.7;
    CGFloat rightViewHeight = heightPercent * kTableviewCellHeight;
    CGFloat rightViewY = (kTableviewCellHeight - rightViewHeight) * 0.5;
    CGRect rightFrame = CGRectMake(0, rightViewY, 80, rightViewHeight);
    rightBtn.frame = rightFrame;
    _codeTextField.rightView = rightBtn;
    _codeTextField.rightViewMode = UITextFieldViewModeAlways;
     [_codeTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
     [_phoneTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)updateCodeBtnUIWith:(BOOL)enable
{
    self.codeBtn.enabled = enable;
    if (enable) {
        [self.codeBtn setBackgroundColor:kCodeBtnEnableStateColor];
        [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.codeBtn.titleLabel.textColor = [UIColor whiteColor];
    }else{
        [self.codeBtn setBackgroundColor:kBtnDisableStateColor];
        [self.codeBtn setTitle:@"60S" forState:UIControlStateNormal];
        self.codeBtn.titleLabel.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark - private methods
- (void)updateRegistBtnEnableStatus
{
    NSString *accountStr = [self.phoneTextField.text strWithoutSpace];;
    NSString *codeStr = [self.codeTextField.text strWithoutSpace];
    if ((accountStr.length > 0)&&(codeStr.length > 0)) {
        self.nextBtn.enabled = YES;
    }else{
        self.nextBtn.enabled = NO;
    }
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


#pragma mark -  IBaction methods
- (IBAction)requestRegisterCode
{
    NSString *phoneTxt = self.phoneTextField.text;
    if (![phoneTxt rightPhoneNumFormat]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    NSString *subUrl = @"user/getCheckCode";
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@%@",BASEURL,subUrl,phoneTxt];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:phoneTxt,kPhone,@"1",kReqType,nil];
    [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id list) {
       [self cuntingDown];
        [SVProgressHUD showErrorWithStatus:msg];
    } reqFail:^(int type, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
       [self cuntingDown];
    }];
}

#pragma mark - selectors
- (void)textDidChange:(UITextField*)sender
{
    [self updateRegistBtnEnableStatus];
}



- (void)closeEye:(id)sender
{
//    UIButton *button = (UIButton *)sender;
//    button.selected = !button.selected;
//    
//    if (button.selected) {
//        self.pwdTextField.secureTextEntry = NO;
//        UIImage *imgOpen = [UIImage imageNamed:@"password-eye-r"];
//        [button setImage:imgOpen forState:UIControlStateSelected];
//        
//    } else {
//        self.pwdTextField.secureTextEntry = YES;
//        UIImage *imgClose = [UIImage imageNamed:@"uneye"];
//        [button setImage:imgClose forState:UIControlStateNormal];
//    }
}

- (IBAction)tapNextBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"pwdbackSegue" sender:nil];
    NSString *phoneTxt = self.phoneTextField.text;
    NSString *codeTxt = self.codeTextField.text;
//    NSString *pwdTxt = self.pwdTextField.text;
    [self.view endEditing:YES];
    if (![phoneTxt rightPhoneNumFormat]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }else if(codeTxt.length <= 0){
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }else{
    }
}


#pragma mark - requset server
- (void)requestServerModifyPwdWithParams:(NSDictionary*)params
{}

#pragma mark - private metods
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


@end
