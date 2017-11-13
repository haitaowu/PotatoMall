//
//  UnionedMembersController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "UnionedMembersController.h"
#import "plantmodel.h"
#import "UnionedMemCell.h"
#import "UnionedMemHeader.h"
#import "UnionedObserHeader.h"
#import "UnionAddMemberController.h"

static NSString *UnionedMemHeaderID = @"UnionedMemHeaderID";
static NSString *UnionedObserHeaderID = @"UnionedObserHeaderID";
static NSString *MemberCellID = @"MemberCellID";


#define kMemberSectionIdx               0

@interface UnionedMembersController ()
@property(nonatomic,weak) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray *membersArray;
@property(nonatomic,strong) NSMutableArray *originMembersArray;
@property(nonatomic,strong) NSMutableArray *obsersArray;
@property(nonatomic,strong) UnionedMemHeader *memHeader;
@end


@implementation UnionedMembersController
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
    if ([segue.identifier isEqualToString:@"addMemSegue"]) {
        UnionAddMemberController *vc = segue.destinationViewController;
        vc.unionId = self.unionId;
    }
}

#pragma mark - private methods
- (void)updateCellEditStatue:(BOOL)state
{
    for (plantmodel *model in self.membersArray) {
        model.isEditing = state;
    }
    [self.tableView reloadData];
}

//深拷贝容器类中的自定义类。
- (NSMutableArray*)deepMutableArray:(NSArray*)array
{
    NSMutableArray *deepArray = [NSMutableArray array];
    for (id obj in array) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *mutableArray = [self deepMutableArray:obj];
            [deepArray addObject:mutableArray];
        }else{
            [deepArray addObject:[obj mutableCopy]];
        }
    }
    return deepArray;
}

//筛选观察员数据
- (void)sortMemberObersByAllUsers:(NSArray*)users
{
    NSMutableArray *members = [NSMutableArray array];
    NSMutableArray *obsers = [NSMutableArray array];
    //成员类别 1种植用户 2观察员
    for (plantmodel *obj in users) {
        if ([obj.userType isEqualToString:@"1"]) {
            [members addObject:obj];
        }else{
            [obsers addObject:obj];
        }
    }
    self.originMembersArray = members;
    self.membersArray = self.originMembersArray;
#warning test add 
    self.obsersArray = members;
//    self.obsersArray = obsers;
    [self.tableView reloadData];
}

#pragma mark - setup
- (void)setupBase
{
    NSDictionary *params = [self umionedMembersParams];
    [self reqUnionedMembers:params];
}

- (void)setupTableview
{
    UINib *memNib = [UINib nibWithNibName:@"UnionedMemCell" bundle:nil];
    [self.tableView registerNib:memNib forCellReuseIdentifier:MemberCellID];
    
    UINib *UnionedMemHeaderNib = [UINib nibWithNibName:@"UnionedMemHeader" bundle:nil];
    [self.tableView registerNib:UnionedMemHeaderNib forHeaderFooterViewReuseIdentifier:UnionedMemHeaderID];
    
    UINib *UnionedObserHeaderNib = [UINib nibWithNibName:@"UnionedObserHeader" bundle:nil];
    [self.tableView registerNib:UnionedObserHeaderNib forHeaderFooterViewReuseIdentifier:UnionedObserHeaderID];
}

#pragma mark - selectors
- (IBAction)managebuttonclick:(id)sender {
//     [SVProgressHUD showErrorWithStatus:@"您不是管理员,无法操作"];
}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == kMemberSectionIdx) {
//        if (self.membersArray.count > 0) {
        if (self.memHeader == nil) {
            UnionedMemHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:UnionedMemHeaderID];
            self.memHeader = header;
            __block typeof(self) blockSelf = self;
            header.memEditCanceBlock = ^{
                blockSelf.membersArray = self.originMembersArray;
                [blockSelf.tableView reloadData];
//                [blockSelf updateCellEditStatue:NO];
            };

            header.memEditConfirmBlock = ^{
                [blockSelf reqSetAdministrators];
                [blockSelf updateCellEditStatue:NO];
            };
            
            header.adminEditBlock = ^(BOOL state){
                blockSelf.membersArray = [self deepMutableArray:self.originMembersArray];
                [blockSelf updateCellEditStatue:state];
            };
        }
        [self.memHeader updateUIWithMemsCount:[self.membersArray count]];
//            __block typeof(self) blockSelf = self;
//            header.helpBlock = ^{
//            };
        return self.memHeader;
//        }else{
//            return [UIView new];
//        }
    }else{
        UnionedObserHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:UnionedObserHeaderID];
        [header updateUIWithObserCount:[self.obsersArray count]];
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (kMemberSectionIdx == section) {
        return 10;
    }else{
        return 0.001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kMemberSectionIdx) {
        return [self.membersArray count];
    }else{
        return [self.obsersArray count];
    }
}

//1 创建人 2 管理员 3普通用户
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kMemberSectionIdx) {
        UnionedMemCell *cell = [tableView dequeueReusableCellWithIdentifier:MemberCellID];
        plantmodel *model = [self.membersArray objectAtIndex:indexPath.row];
        __block typeof(self) blockSelf = self;
        cell.addAdminBlock = ^(plantmodel *model) {
            [blockSelf.tableView reloadData];
        };
        
        cell.delAdminBlock = ^(plantmodel *model) {
            [blockSelf.tableView reloadData];
        };

        cell.model = model;
        return cell;
    }else{
        UnionedMemCell *cell = [tableView dequeueReusableCellWithIdentifier:MemberCellID];
        plantmodel *model = [self.membersArray objectAtIndex:indexPath.row];
        cell.obserModel = model;
        return cell;
    }
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
                [self sortMemberObersByAllUsers:array];
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

//设置管理员的请求参数
- (NSMutableArray *)adminMembersParams
{
    NSMutableArray *params = [NSMutableArray array];
    //成员类别 1种植用户 2观察员
    for (plantmodel *obj in self.membersArray) {
        if ([obj.unionType isEqualToString:@"2"]) {
            NSMutableDictionary *admin = [NSMutableDictionary dictionary];
            admin[@"unionType"] = obj.unionType;
            admin[@"uid"] = obj.uid;
            [params addObject:admin];
        }
    }
    return params;
}

//请求设置管理员
- (void)reqSetAdministrators
{
    NSArray *params = [self adminMembersParams];
    if (params.count <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择要设置的成员"];
        return;
    }
    
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"user_union/updateBatchUnionUsers";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
                NSString *obj = [dict strValueForKey:@"obj"];
                if ([obj isEqualToString:@"1"]) {
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"设置失败"];
                    self.membersArray = self.originMembersArray;
                }
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
                self.membersArray = self.originMembersArray;
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            self.membersArray = self.originMembersArray;
            [self.tableView reloadData];
        }];
    }
}

@end
