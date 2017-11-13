//
//  AddMemberValidController.m
//  PotatoMall
//
//  Created by taotao on 2017/10/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "AddMemberValidController.h"
#import "SVProgressHUD.h"


@interface AddMemberValidController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeField;


@end

@implementation AddMemberValidController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneLabel.text = self.phoneNum;
    
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

#pragma mark - selectors
//继续添加成员
- (IBAction)tapContinueBtn:(UIButton*)sender{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
//提交
- (IBAction)tapValidateBtn:(UIButton*)sender{
    NSString *codeStr = self.codeField.text;
    if (codeStr.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"输入验证码"];
        return;
    }
   [self.view endEditing:YES];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNum,kPhone,codeStr,kVerfiyCode,nil];
    [self requestValidateCodeWithParams:params];
}




#pragma mark - requset server
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
