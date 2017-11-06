//
//  UnionedPlanedRecordController.m
//  PotatoMall
//
//  Created by taotao on 2017/11/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "UnionedPlanedRecordController.h"
#import "PlanOptHeader.h"
#import "PlanFollowHeader.h"
#import "PlanOptFooter.h"
#import "plantmodel.h"
#import "PlanRecordTableViewControl.h"
#import "PlanWebViewViewController.h"

#define kPlanedInfoSectionIdx             0
#define kOptHelpSectionIdx                1
#define kFllowPlanSectionIdx              2

static NSString *PlanOptHeaderID = @"PlanOptHeaderNibID";
static NSString *PlanFollowHeaderID = @"PlanFollowHeaderNibID";
static NSString *PlanOptFooterID = @"PlanOptFooterNibID";


@interface UnionedPlanedRecordController ()
@property (weak, nonatomic) IBOutlet UILabel *platAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *platAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *catalogNameLabel;
@property(nonatomic,strong) NSArray *plaRecords;
@property(nonatomic,strong) NSArray *planTypes;
@property(nonatomic,strong) NSDictionary *planInfo;
@end

@implementation UnionedPlanedRecordController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupBase];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"finishedSegue"]) {
        PlanRecordTableViewControl *vc = segue.destinationViewController;
        vc.platRecords = self.plaRecords;
    }
}

#pragma mark - private methods
- (BOOL)isReviewing
{
    if ([self.planState isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)setupUI
{
    UINib *PlanOptHeaderNib = [UINib nibWithNibName:@"PlanOptHeader" bundle:nil];
    [self.tableView registerNib:PlanOptHeaderNib forHeaderFooterViewReuseIdentifier:PlanOptHeaderID];
    
    UINib *PlanFollowHeaderNib = [UINib nibWithNibName:@"PlanFollowHeader" bundle:nil];
    [self.tableView registerNib:PlanFollowHeaderNib forHeaderFooterViewReuseIdentifier:PlanFollowHeaderID];
    
    UINib *PlanOptFooterNib = [UINib nibWithNibName:@"PlanOptFooter" bundle:nil];
    [self.tableView registerNib:PlanOptFooterNib forHeaderFooterViewReuseIdentifier:PlanOptFooterID];
}

- (void)setupBase
{
    //1.种植信息类型查询
    NSDictionary *paramPlantedType = [self paramPlantedType];
    [self findSysDictByType:paramPlantedType];
    //2.查询种植信息
    NSDictionary *paramsPlantedInfo = [self userParams];
    [self detailUserPlat:paramsPlantedInfo];
    //3.植保记录- 请求参数
    NSDictionary *userRecordParams = [self userRecordParams];
    [self findUserPlatRecord:userRecordParams];
}

- (void)updateUIAfterReq
{
    if ((self.planInfo == nil) || (self.planTypes == nil) || (self.plaRecords == nil)){
        return;
    }
    
    NSString *platAddress = [self.planInfo strValueForKey:@"platAddress"];
    NSString *platArea = [self.planInfo strValueForKey:@"platArea"];
    NSString *platType = [self.planInfo strValueForKey:@"platType"];
    NSString *catalogName = @"";
    for (plantmodel *obj in self.planTypes) {
        if ([obj.uid isEqualToString:platType]) {
            catalogName = obj.name;
            break;
        }
    }
    self.catalogNameLabel.text = catalogName;
    self.platAreaLabel.text = platArea;
    self.platAddressLabel.text = platAddress;
}


#pragma mark - selectors

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == kOptHelpSectionIdx) {
        return 50;
    }else if (section == kFllowPlanSectionIdx) {
        return 60;
    }else{
        return 0.001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == kOptHelpSectionIdx) {
        PlanOptHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PlanOptHeaderID];
        //    __block typeof(self) blockSelf = self;
        header.helpBlock = ^{
            NSLog(@"tap on option help block");
        };
        return header;
    }else if (section == kFllowPlanSectionIdx) {
        PlanFollowHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PlanFollowHeaderID];
        //    __block typeof(self) blockSelf = self;
        header.helpBlock = ^{
            NSLog(@"tap on option help block");
        };
        return header;
    }else {
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
     if (section == kOptHelpSectionIdx) {
         return 50;
     }else{
         return 0.001;
     }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == kOptHelpSectionIdx) {
        PlanOptFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PlanOptFooterID];
//        __block typeof(self) blockSelf = self;
        footer.confirmBlock = ^{
            NSLog(@"tap on confirm btn ");
//            PlanWebViewViewController *webViewController = [[PlanWebViewViewController alloc] init];
//            webViewController.murl = murl;
//            [blockSelf.navigationController pushViewController:webViewController animated:YES];
        };
        return footer;
    }else{
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kFllowPlanSectionIdx) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        cell.textLabel.text = [NSString stringWithFormat:@"indxRow = %ld",indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
}


#pragma mark - requset server
 //1.种植信息类型查询 - 请求参数
 - (NSDictionary *)paramPlantedType
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"2";
    return params;
}

 //1.种植信息类型查询
- (void)findSysDictByType:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/system/findSysDictByType";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
            NSMutableArray *type =[plantmodel plantWithDataArray:data];
            self.planTypes = type;
            [self updateUIAfterReq];
            NSLog(@"planted type =%@",type);
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
}

//2.查询种植信息-请求参数
- (NSDictionary *)userParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    return params;
}


//2.查询种植信息
- (void)detailUserPlat:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/user/detailUserPlat";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
                NSDictionary *plantedInfo = [plantmodel plantWithData:data];
                self.planInfo = plantedInfo;
                NSLog(@"plantedInfo=%@",plantedInfo);
                [self updateUIAfterReq];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
}


//3.植保记录- 请求参数
- (NSDictionary *)userRecordParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    return params;
}



//3.植保记录
- (void)findUserPlatRecord:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/plat/findUserPlatRecord";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
                NSMutableArray *list =[plantmodel plantWithDataArray1:data];
                self.plaRecords = list;
                [self updateUIAfterReq];
                NSLog(@"planted record list =%@",list);
//                [_mtableview reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
}



@end
