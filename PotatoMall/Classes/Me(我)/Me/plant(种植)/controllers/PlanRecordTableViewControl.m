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
    plantmodel *model = self.platRecords[section];
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
    plantmodel *model = self.platRecords[indexPath.section];
//    CGFloat height = ;
    NSString *content = model.content;
    CGFloat height = [self cellHeightWithContent:content];
    return height;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.platRecords count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    plantmodel *model = self.platRecords[section];
    if (model.isOpened == YES) {
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlantRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:PlantRecordCellID];
    plantmodel *model = self.platRecords[indexPath.section];
    cell.model = model;
    return cell;
}


#pragma mark - requset server



@end
