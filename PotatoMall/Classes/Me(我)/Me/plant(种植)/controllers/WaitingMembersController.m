//
//  WaitingMembersController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "WaitingMembersController.h"
#import "plantmodel.h"
#import "WatingValidMemCell.h"
#import "ReValidMemberController.h"

static NSString *MemValidateCelID = @"MemValidateCelID";


#define kMemberSectionIdx               0

@interface WaitingMembersController ()
@property(nonatomic,strong) NSArray *membersArray;
@end


@implementation WaitingMembersController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reqUnValidMembers];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"reValidateSegue"]) {
        ReValidMemberController *vc = segue.destinationViewController;
        vc.model = sender;
    }
}

#pragma mark - private methods
- (void)filterUnValidateMembersWith:(NSArray*)array
{
    NSMutableArray *unValiMems = [NSMutableArray array];
    //verifyStatu : 1未验证 2已验证
    for (plantmodel *obj in array) {
        if ([obj.verifyStatu isEqualToString:@"1"]) {
            [unValiMems addObject:obj];
        }
    }
    self.membersArray = unValiMems;
    [self.tableView reloadData];
}

#pragma mark - setup
- (void)reqUnValidMembers
{
    NSDictionary *params = [self umionedMembersParams];
    [self reqUnionedMembers:params];
}

- (void)setupTableview
{
    UINib *memNib = [UINib nibWithNibName:@"WatingValidMemCell" bundle:nil];
    [self.tableView registerNib:memNib forCellReuseIdentifier:MemValidateCelID];
}

#pragma mark - selectors
- (IBAction)managebuttonclick:(id)sender {
}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.membersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WatingValidMemCell *cell = [tableView dequeueReusableCellWithIdentifier:MemValidateCelID];
    plantmodel *model=[self.membersArray objectAtIndex:indexPath.row];
    cell.model = model;
    __block typeof(self) blockSelf = self;
    cell.validBlock = ^(id model) {
        [blockSelf performSegueWithIdentifier:@"reValidateSegue" sender:model];
    };
    return cell;
}

#pragma mark - requset server
- (NSDictionary *)umionedMembersParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    return params;
}

- (void)reqUnionedMembers:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"user_union/findUnionUsers";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD dismiss];
                NSArray *array = [plantmodel plantWithDataArray:data];
                [self filterUnValidateMembersWith:array];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
//            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}




@end
