//
//  UnionAddMemberController.m
//  PotatoMall
//
//  Created by taotao on 2017/10/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "UnionAddMemberController.h"
#import "SVProgressHUD.h"


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

#pragma mark - selectors
//提交审核
- (IBAction)tapAddBtn:(UIButton*)sender{
    [self performSegueWithIdentifier:@"validateCodeSegue" sender:nil];
//    NSString *unionName = self.unionNameField.text;
//    NSString *detailAdr = self.detailAdrField.text;
//    NSString *areaStr = self.areaField.text;
//    if (unionName.length <= 0) {
//        [SVProgressHUD showInfoWithStatus:@"输入名称"];
//        return;
//    }else if(self.adrInfo == nil){
//        [SVProgressHUD showInfoWithStatus:@"选择地址"];
//        return;
//    }else if(detailAdr.length <= 0){
//        [SVProgressHUD showInfoWithStatus:@"输入详细地址"];
//        return;
//    }else if(areaStr.length <= 0){
//        [SVProgressHUD showInfoWithStatus:@"输入种植面积"];
//        return;
//    }else{
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"unionName"] = unionName;
//        params[@"infoProvince"] = [self.adrInfo objectForKey:@"infoProvince"];
//        params[@"infoCity"] = [self.adrInfo objectForKey:@"infoCity"];
//        params[@"infoCounty"] = [self.adrInfo objectForKey:@"infoCounty"];
//        params[@"infoAddress"] = detailAdr;
//        params[@"applyArea"] = areaStr;
//        params[@"checkStatus"] = @"1";
//        UserModel *model = [UserModelUtil sharedInstance].userModel;
//        params[@"belongUserId"] = model.userId;
//        [self submitCreateUnionWith:params];
//    }
    HTLog(@"tapSubmitReqBtn");
}



#pragma mark - requset server
- (void)submitCreateUnionWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        NSString *subUrl = @"user_union/saveOrUpdateUserUnion";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params attach:nil reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"创建联合体成功"];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            HTLog(@"error msg = %@",msg);
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
