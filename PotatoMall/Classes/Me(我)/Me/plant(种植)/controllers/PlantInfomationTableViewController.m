//
//  PlantInfomationTableViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlantInfomationTableViewController.h"
#import "plantmodel.h"
@interface PlantInfomationTableViewController ()

@end

@implementation PlantInfomationTableViewController

#pragma mark - Overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *detailUserUnionparama=[self detailUserUnion];
    [self detailUserUnion:detailUserUnionparama];
}

#pragma mark - requset server
- (void)detailUserUnion:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/user_union/detailUserUnion";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
                
                data=[plantmodel plantWithData:data];
                self.createDate.text=[data objectForKey:@"createDate"];
                self.place.text=[NSString stringWithFormat:@"%@ %@ %@",[data objectForKey:@"infoProvinceName"],[data objectForKey:@"infoCityName"],[data objectForKey:@"infoCountyName"]];
                self.address.text=[data objectForKey:@"infoAddress"];
                self.area.text=[NSString stringWithFormat:@"%@亩",[data objectForKey:@"platArea"]];
                self.peoplenum.text=[NSString stringWithFormat:@"%@户",[data objectForKey:@"userNum"]];
                self.type.text=[data objectForKey:@"platTypeName"];
                UserModel *model = [UserModelUtil sharedInstance].userModel;
                self.phonenum.text=model.phone;
                
                NSURL *photourl = [NSURL URLWithString:model.customerImg];
                //url请求实在UI主线程中进行的
                UIImage *images = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl]];
                self._logoimage.image = images;
                self._logoimage.layer.masksToBounds = YES;
                self._logoimage.layer.cornerRadius = 18;
                
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}


- (NSDictionary *)detailUserUnion
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    return params;
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}



////指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}



@end
