//
//  JoinedPlanedOptionController.m
//  PotatoMall
//
//  Created by taotao on 2017/11/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

/**
 *加入植保计划的植保操作界面
 *包括 加入合作社、未加入合作社用户
 */

#import "JoinedPlanedOptionController.h"
#import "PlanOptHeader.h"
#import "PlanFollowHeader.h"
#import "PlanOptFooter.h"
#import "plantmodel.h"
#import "PlanRecordTableViewControl.h"
#import "PlanWebViewViewController.h"
#import "PlantRecordCell.h"
#import "PlantListTableViewCell.h"
#import "NSDate+Extension.h"

#define kOptHelpSectionIdx                0
#define kFllowPlanSectionIdx              1

static NSString *PlantRecordCellID = @"PlantRecordCellID";
static NSString *FollowRecordCellID = @"FollowRecordCellID";
static NSString *PlanOptHeaderID = @"PlanOptHeaderNibID";
static NSString *PlanFollowHeaderID = @"PlanFollowHeaderNibID";
static NSString *PlanOptFooterID = @"PlanOptFooterNibID";


@interface JoinedPlanedOptionController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (weak, nonatomic) IBOutlet UILabel *platAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *platAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *catalogNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray *plaRecords;
@property(nonatomic,strong) NSArray *planTypes;
@property(nonatomic,strong) NSMutableArray *marchRecords;
@property(nonatomic,strong) NSMutableArray *followRecords;
@property(nonatomic,strong) NSDictionary *planInfo;
@property(nonatomic,assign) BOOL followOpend;
@property(nonatomic,strong)  PlanOptFooter *optFooter;
@end

@implementation JoinedPlanedOptionController

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
        vc.unionId = self.unionId;
//        vc.platRecords = self.plaRecords;
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
    
    UINib *PlantRecordCellNib = [UINib nibWithNibName:@"PlantRecordCell" bundle:nil];
    [self.tableView registerNib:PlantRecordCellNib forCellReuseIdentifier:PlantRecordCellID];
    
    UINib *recordNib = [UINib nibWithNibName:@"PlantListTableViewCell" bundle:nil];
    [self.tableView registerNib:recordNib forCellReuseIdentifier:FollowRecordCellID];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
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
    if ((self.planInfo == nil) || (self.planTypes == nil)){
        return;
    }
    
    NSString *platAddress = [self.planInfo strValueForKey:@"platAddress"];
    NSString *platArea = [self.planInfo strValueForKey:@"platArea"];
    NSString *platType = [self.planInfo strValueForKey:@"platType"];
    NSString *catalogName = @"";
    for (plantmodel *obj in self.planTypes) {
        NSLog(@"obj.name = %@ uid = %@",obj.name,obj.uid);
        if ([obj.uid isEqualToString:platType]) {
            catalogName = obj.name;
            break;
        }
    }
    self.catalogNameLabel.text = catalogName;
    self.platAreaLabel.text = platArea;
    self.platAddressLabel.text = platAddress;
}

- (void)sortRecordsWithArray:(NSArray*)array
{
    NSMutableArray *unFinishedArray = [NSMutableArray array];
    for (plantmodel *model in array) {
        if ([model.status isEqualToString:@"1"]) {
            [unFinishedArray addObject:model];
        }
    }
    NSDate *today = [NSDate date];
    NSDate *ymdToday = [today ymdDate];
    NSMutableArray *marchRecords = [NSMutableArray array];
    self.marchRecords = marchRecords;
    NSMutableArray *followRecords = [NSMutableArray array];
    self.followRecords = followRecords;
    for (plantmodel *model in unFinishedArray) {
        if (model.platDate == nil) {
            [marchRecords addObject:model];
        }else{
            NSString *intervalStr = model.platDate;
            NSTimeInterval interval = [intervalStr doubleValue] / 1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
            NSDate *ymdDate = [date ymdDate];
            NSTimeInterval betInterval = [ymdToday timeIntervalSinceDate:ymdDate];
            if (betInterval <= 0) {
                [marchRecords addObject:model];
            }else{
                [followRecords addObject:model];
            }
        }
    }
    
    for(int i = 0 ; i < marchRecords.count ; i ++){
        plantmodel *iModel = marchRecords[i];
        NSTimeInterval iTimeInterval = [iModel.platDate doubleValue];
        for (int j = i + 1; j < marchRecords.count; j++) {
            plantmodel *jModel = marchRecords[j];
            NSTimeInterval jTimeInterval = [jModel.platDate doubleValue];
            if (iTimeInterval < jTimeInterval) {
                [marchRecords exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    [self.tableView reloadData];
}


- (CGFloat)cellHeightWithContent:(NSString*)contentStr
{
    CGFloat height = 16;
    CGFloat imgVH = 100;
    UIFont *font = [UIFont systemFontOfSize:14];
    CGFloat labelWidth = kScreenWidth - 8 * 2;
    if ([contentStr containsString:@"\r\n"]) {
        NSArray *countArray = [contentStr componentsSeparatedByString:@"\r\n"];
        for (NSString *str in countArray) {
            NSString *replStr = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
            CGFloat rowHeight = [CommHelper strHeightWithStr:replStr font:font width:labelWidth];
            height += rowHeight;
        }
    }else{
        height = [CommHelper strHeightWithStr:contentStr font:font width:16];
    }
    height += imgVH;
    return height;
}

- (void)showOptionViewWithModel:(plantmodel*)model{
    
    PlanWebViewViewController *_PlanWebViewViewController = [[PlanWebViewViewController alloc] init];
    _PlanWebViewViewController.murl = model.helpUrl;
    [self.navigationController pushViewController:_PlanWebViewViewController animated:YES];
}

- (BOOL)shouldDisplayEmptyTitle
{
    if ((self.marchRecords != nil) && (self.marchRecords.count == 0)){
        if ((self.followRecords != nil) && (self.followRecords.count == 0)){
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

#pragma mark - selectors

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == kOptHelpSectionIdx) {
        if (self.marchRecords.count > 0) {
            return 60;
        }else{
            return 0.01;
        }
    }else {
        if (self.followRecords.count > 0) {
            return 60;
        }else{
            return 0.01;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == kOptHelpSectionIdx) {
        if (self.marchRecords.count > 0) {
            PlanOptHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PlanOptHeaderID];
            __block typeof(self) blockSelf = self;
            header.helpBlock = ^{
                plantmodel *model = [blockSelf.marchRecords firstObject];
                if (model != nil) {
                    PlanWebViewViewController *webViewController = [[PlanWebViewViewController alloc] init];
                    webViewController.murl = model.helpUrl;
                    [blockSelf.navigationController pushViewController:webViewController animated:YES];
                    NSLog(@"tap on option help block");
                }
            };
            return header;
        }else{
            return [UIView new];
        }
    }else{
        if (self.followRecords.count > 0) {
            PlanFollowHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PlanFollowHeaderID];
            __block typeof(self) blockSelf = self;
            header.openStateBlock = ^(BOOL isOpen){
                NSLog(@"tap on option help block");
                blockSelf.followOpend = isOpen;
                [blockSelf.tableView reloadData];
            };
            return header;
        }else{
            return [UIView new];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
     if (section == kOptHelpSectionIdx) {
         if (self.marchRecords.count > 0) {
             CGFloat height = [self.optFooter.imgsView itemsWHeight] + 50;
             return height;
         }else{
             return 0.001;
         }
     }else{
         return 0.001;
     }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == kOptHelpSectionIdx) {
        if (self.optFooter == nil) {
            PlanOptFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PlanOptFooterID];
            footer.imgsView.currentController = self;
            __block typeof(self) blockSelf = self;
            footer.confirmBlock = ^{
                NSLog(@"tap on confirm btn ");
                plantmodel *model = [blockSelf.marchRecords firstObject];
                if (model != nil) {
                    [blockSelf updatePlateRecordWith:model];
                }
            };
            self.optFooter = footer;
        }
        if (self.marchRecords.count > 0) {
            return self.optFooter;
        }else{
            return [UIView new];
        }
    }else{
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (indexPath.section == kFllowPlanSectionIdx) {
         return 50;
     }else{
         plantmodel *model = [self.marchRecords firstObject];
         NSString *content = model.content;
         CGFloat imgVH = 100;
         CGFloat height = [self cellHeightWithContent:content];
         height = height - imgVH;
         return height;
     }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kOptHelpSectionIdx){
        if (self.marchRecords.count > 0) {
            return 1;
        }else{
            return 0;
        }
    }else{
        if (self.followOpend == YES) {
            return [self.followRecords count];
        }else{
            return 0;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kFllowPlanSectionIdx) {
        PlantListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FollowRecordCellID];
        plantmodel *model = self.followRecords[indexPath.row];
        cell.model = model;
        __block typeof(self) blockSelf = self;
        cell.optBlock = ^(plantmodel *model) {
            [blockSelf showOptionViewWithModel:model];
        };
        return cell;
    }else{
        PlantRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:PlantRecordCellID];
        plantmodel *model = [self.marchRecords firstObject];
//        cell.model = model;
        [cell updateUIWithOutImg:model];
        return cell;
    }
}


#pragma mark - DZNEmptyDataSetSource Methods
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -144;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if ([RequestUtil networkAvaliable] == NO) {
        NSString *text = @"咦！断网了";
        NSAttributedString *txt = [CommHelper emptyTitleWithTxt:text];
        return txt;
    }else if ([self shouldDisplayEmptyTitle]){
        [self.tableView.mj_footer setHidden:YES];
        NSString *text = @"暂无植保记录";
        NSAttributedString *txt = [CommHelper emptyTitleWithTxt:text];
        return txt;
    }else{
        return [[NSAttributedString alloc] init];
    }
}

#pragma mark - requset server
 //1.种植信息类型查询 - 请求参数
 - (NSDictionary *)paramPlantedType
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"type"] = @"2";
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
//                [SVProgressHUD showSuccessWithStatus:msg];
                [SVProgressHUD dismiss];
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
    if (self.unionId != nil) {
        params[@"unionId"] = self.unionId;
    }
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
                [SVProgressHUD dismiss];
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
    if (self.unionId != nil) {
        params[@"unionId"] = self.unionId;
        params[@"type"] = @"1";
    }else{
        params[@"type"] = @"2";
    }
    return params;
}


//3.植保记录
- (void)findUserPlatRecord:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"plat/findUserPlatRecord";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
//                [SVProgressHUD showSuccessWithStatus:msg];
                [SVProgressHUD dismiss];
                NSMutableArray *list =[plantmodel plantWithDataArray1:data];
                self.plaRecords = list;
                [self sortRecordsWithArray:list];
                NSLog(@"planted record list =%@",list);
//                [_mtableview reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
                self.marchRecords = [NSMutableArray array];
                self.followRecords = [NSMutableArray array];
                [self.tableView reloadData];
            }

        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            self.marchRecords = [NSMutableArray array];
            self.followRecords = [NSMutableArray array];
        }];
    }
}

- (void)updatePlateRecordWith:(plantmodel*)model
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"platTemplateDetailId"] = model.platTemplateDetailId;
    params[@"uid"] = model.uid;
    params[@"catalogName"] = model.catalogName;
    params[@"content"] = model.content;
    params[@"imagesUrls"] = model.imagesUrls;
    params[@"score"] = model.score;
    params[@"sort"] = model.sort;
    params[@"status"] = model.status;
    params[@"platDate"] = model.platDate;
    params[@"purchase"] = @"purchase";
    params[@"platSendRecordId"] = @"platSendRecordId";
    [self updatePlateRecordWithParams:params];
}

//更新植保记录
- (void)updatePlateRecordWithParams:(NSDictionary*)params
{
    NSMutableArray *imgs = self.optFooter.imgs;
    [imgs removeLastObject];
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"plat/updateUserPlatRecord";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params attachs:imgs reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD dismiss];
                NSMutableArray *list =[plantmodel plantWithDataArray1:data];
                self.plaRecords = list;
                [self sortRecordsWithArray:list];
                NSLog(@"planted record list =%@",list);
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}
@end
