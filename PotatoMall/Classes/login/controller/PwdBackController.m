//
//暂时不用。 
//  
//
//  Created by pactera on 5/3/16.
//  Copyright © 2016 taotao. All rights reserved.

//

#import "PwdBackController.h"
#import "SVProgressHUD.h"


#define kSectionCount                           1
#define kSectionFirstIdx                        0
#define kRowsCountSectionFirst                  3



@interface PwdBackController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdNewTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdAginTextField;
@end

@implementation PwdBackController

- (void)viewDidLoad {
    //left navigationBar item
//    UIImage *leftImage =[UIImage imageNamed:@"arrow-left.png"];
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBtn setImage:leftImage forState:UIControlStateNormal];
//    leftBtn.frame = CGRectMake(0, 0, 30, 30);
//    [leftBtn addTarget:self action:@selector(tapBackBtn:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    
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
- (void)tapBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapPwdBackrBtn:(id)sender {
    
//    NSString *pwdTxt = self.pwdNewTextField.text;
//    NSString *pwdAginTxt = self.pwdAginTextField.text;
//        if (pwdTxt.length <= 0) {
//            [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
//            return;
//        }else if(pwdAginTxt.length <= 0){
//            [SVProgressHUD showErrorWithStatus:@"请再次输入密码"];
//            return;
//        }else if(![pwdAginTxt isEqualToString:pwdTxt]){
//            [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
//            return;
//        }else{
//            
//            NSString *subUrl = @"api/ur/resetPassword";
//            NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASE_URL2,subUrl];
//            NSString *encryPwdTxt = [UserUtil encryPwdWithPassword:pwdTxt];
//            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.params];
//            params[@"password"] = encryPwdTxt;
//            [HttpTools POSTWithURL:reqUrl params:params reqSuccess:^(int status,NSString *msg, id entity, id list) {
//                [SVProgressHUD showSuccessWithStatus:msg];
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            } reqFail:^(StatusType type,NSString* msg) {
//                [SVProgressHUD showErrorWithStatus:msg];
//            }];
//        }
}




@end
