//
//  UnionedBillsController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "UnionedBillsController.h"
#import "plantmodel.h"
#import "UnionedBillCell.h"
#import "UnionBillFooter.h"
#import "UnionedObserHeader.h"
#import "OrderDetailTableController.h"
#import "UnionAddMemberController.h"

static NSString *BillFooterID = @"BillFooterID";
static NSString *UnionedObserHeaderID = @"UnionedObserHeaderID";
static NSString *UnionBillCellID = @"UnionBillCellID";


#define kMemberSectionIdx               0

@interface UnionedBillsController ()
@property(nonatomic,weak) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray *billsArray;
@end


@implementation UnionedBillsController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联合体成员";
    [self setupTableview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupBase];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"addMemSegue"]) {
//        UnionAddMemberController *vc = segue.destinationViewController;
//        vc.unionId = self.unionId;
//    }
}

#pragma mark - private methods

#pragma mark - setup
- (void)setupBase
{
    NSDictionary *params = [self billsParams];
    [self reqUnionedBillsWith:params];
}

- (void)setupTableview
{
    UINib *billNib = [UINib nibWithNibName:@"UnionedBillCell" bundle:nil];
    [self.tableView registerNib:billNib forCellReuseIdentifier:UnionBillCellID];
    
    UINib *UnionBillFooterNib = [UINib nibWithNibName:@"UnionBillFooter" bundle:nil];
    [self.tableView registerNib:UnionBillFooterNib forHeaderFooterViewReuseIdentifier:BillFooterID];
}

//显示订单详情
- (void)showBillDetailWithModel:(NSDictionary*)billModel
{
    NSLog(@"show bill order detail...");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    OrderDetailTableController *detail = [storyboard instantiateViewControllerWithIdentifier:@"OrderDetailTableController"];
    NSString *changeCode = [billModel strValueForKey:@"changeCode"];
    detail.changeCode = changeCode;
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSDictionary *billModel = self.billsArray[section];
    NSString *changeType = [billModel strValueForKey:@"changeType"];
    if([changeType isEqualToString:@"11"]){
        return 50;
    }else{
        return 0.001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary *billModel = self.billsArray[section];
    NSString *changeType = [billModel strValueForKey:@"changeType"];
    if([changeType isEqualToString:@"11"]){
        UnionBillFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BillFooterID];
        __block typeof(self) blockSelf = self;
        footer.billDetailBlock = ^(NSInteger idx) {
            [blockSelf showBillDetailWithModel:billModel];
        };
        return footer;
    }else{
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.billsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
//    return [self.billsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UnionedBillCell *cell = [tableView dequeueReusableCellWithIdentifier:UnionBillCellID];
    NSDictionary *model = [self.billsArray objectAtIndex:indexPath.section];
    cell.model = model;
    return cell;
}


#pragma mark - requset server
- (NSDictionary *)billsParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    params[@"type"] = @"1";
    return params;
}

- (void)reqUnionedBillsWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"wallet/findWalletLogs";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD dismiss];
                NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
                NSArray *obj = [dict objectForKey:@"obj"];
                self.billsArray = obj;
                NSLog(@"obj = %@",obj);
//                self.originMembersArray = [NSMutableArray arrayWithArray:array];
//                self.membersArray = [self deepMutableArray:self.originMembersArray];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}



@end
