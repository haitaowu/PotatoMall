//
//  PlanRecordTableViewControl.m
//  PotatoMall
//
//  Created by taotao on 2017/11/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlanRecordTableViewControl.h"
#import "PlanOptHeader.h"
#import "PlantRecordHeader.h"
#import "PlanOptFooter.h"
#import "PlantRecordCell.h"


static NSString *PlantRecordCellID = @"PlantRecordCellID";
static NSString *PlantRecordHeaderID = @"PlantRecordHeaderNibID";
static NSString *PlanOptFooterID = @"PlanOptFooterNibID";


@interface PlanRecordTableViewControl ()
@property (weak, nonatomic) IBOutlet UILabel *platAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *platAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *catalogNameLabel;
@property(nonatomic,strong) NSArray *plaRecords;
@property(nonatomic,strong) NSArray *finishedRecords;
@end

@implementation PlanRecordTableViewControl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupBase];
}

#pragma mark - private methods
- (void)setupUI
{
    UINib *PlantRecordHeaderNib = [UINib nibWithNibName:@"PlantRecordHeader" bundle:nil];
    [self.tableView registerNib:PlantRecordHeaderNib forHeaderFooterViewReuseIdentifier:PlantRecordHeaderID];
    UINib *PlantRecordCellNib = [UINib nibWithNibName:@"PlantRecordCell" bundle:nil];
    [self.tableView registerNib:PlantRecordCellNib forCellReuseIdentifier:PlantRecordCellID];
}

- (void)setupBase
{
    NSDictionary *params = [self userRecordParams];
    [self reqUserPlatRecord:params];
}

- (void)fileterFinishedRecordsUpdateUIWithRecords:(NSArray*)records
{
    NSMutableArray *array = [NSMutableArray array];
    //1 未审核 2 已审核 3无效
    for (plantmodel *model in records) {
        if ([model.status isEqualToString:@"2"]) {
            [array addObject:model];
        }
    }
    self.finishedRecords = array;
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
#pragma mark - selectors

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PlantRecordHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PlantRecordHeaderID];
    plantmodel *model = self.finishedRecords[section];
    header.model = model;
    __block typeof(self) blockSelf = self;
    header.optBlock = ^(plantmodel *model){
        [blockSelf.tableView reloadData];
        NSLog(@"tap on optBlock");
    };
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    plantmodel *model = self.finishedRecords[indexPath.section];
    NSString *content = model.content;
    CGFloat height = [self cellHeightWithContent:content];
    return height;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.finishedRecords count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    plantmodel *model = self.finishedRecords[section];
    if (model.isOpened == YES) {
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlantRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:PlantRecordCellID];
    plantmodel *model = self.finishedRecords[indexPath.section];
    cell.model = model;
    return cell;
}


#pragma mark - requset server
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
- (void)reqUserPlatRecord:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/plat/findUserPlatRecord";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD dismiss];
            if (status == StatusTypSuccess) {
                NSMutableArray *list =[plantmodel plantWithDataArray1:data];
//                self.plaRecords = list;
                [self fileterFinishedRecordsUpdateUIWithRecords:list];
                NSLog(@"planted record list =%@",list);
            }else{
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
}



@end
