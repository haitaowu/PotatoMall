//
//  UnionAddMemberController.m
//  PotatoMall
//合作社-添加成员-请求验证码界面
//  Created by taotao on 2017/10/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "UnionAddMemberController.h"
#import "SVProgressHUD.h"
#import "AddMemberValidController.h"
#import "WaitingMembersController.h"

@interface UnionAddMemberController ()
@property (weak, nonatomic) IBOutlet UITextField *memPhoneField;

@end

@implementation UnionAddMemberController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.memPhoneField.layer.borderColor = RGBA(217, 217, 217, 0.8).CGColor;
    self.memPhoneField.layer.borderWidth = 0.8;
    
    UIView *leftView = [[UIView alloc] init];
    CGFloat viewW = 10;
    CGFloat viewH = 50;
    CGRect leftF = CGRectMake(0, 0, viewW, viewH);
    leftView.frame = leftF;
    self.memPhoneField.leftView = leftView;
    self.memPhoneField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"validateCodeSegue"]) {
        AddMemberValidController *vc = segue.destinationViewController;
        vc.phoneNum = self.memPhoneField.text;
    }else if ([segue.identifier isEqualToString:@"waitValidSegue"]) {
        WaitingMembersController *vc = segue.destinationViewController;
        vc.unionId = self.unionId;
    }
}

#pragma mark - selectors
//确认添加成员
- (IBAction)tapAddBtn:(UIButton*)sender{

    NSString *phoneTxt = self.memPhoneField.text;
    if (phoneTxt.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
        return;
    }
    [self.view endEditing:YES];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:phoneTxt,kPhone,@"3",kReqType,nil];
    [self requestCodeWithParams:params];
}



#pragma mark - requset server
//请求验证码
- (void)requestCodeWithParams:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        [SVProgressHUD showWithStatus:@"请求验证码"];
        NSString *subUrl = @"user/getCheckCode";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
                NSLog(@"request validate code data =%@",dict);
                NSString *obj = [dict strValueForKey:@"obj"];
                if ([obj isEqualToString:@"1"]) {
                    [SVProgressHUD dismiss];
                    [self performSegueWithIdentifier:@"validateCodeSegue" sender:nil];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"用户不存在"];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
                //            [SVProgressHUD showErrorWithStatus:@"请求验证码失败"];
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
