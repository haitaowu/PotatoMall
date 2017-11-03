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

#define kPlanedInfoSectionIdx             0
#define kOptHelpSectionIdx                1
#define kFllowPlanSectionIdx              2

static NSString *PlanOptHeaderID = @"PlanOptHeaderNibID";
static NSString *PlanFollowHeaderID = @"PlanFollowHeaderNibID";
static NSString *PlanOptFooterID = @"PlanOptFooterNibID";


@interface UnionedPlanedRecordController ()

@end

@implementation UnionedPlanedRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *PlanOptHeaderNib = [UINib nibWithNibName:@"PlanOptHeader" bundle:nil];
    [self.tableView registerNib:PlanOptHeaderNib forHeaderFooterViewReuseIdentifier:PlanOptHeaderID];

    UINib *PlanFollowHeaderNib = [UINib nibWithNibName:@"PlanFollowHeader" bundle:nil];
    [self.tableView registerNib:PlanFollowHeaderNib forHeaderFooterViewReuseIdentifier:PlanFollowHeaderID];
    
    UINib *PlanOptFooterNib = [UINib nibWithNibName:@"PlanOptFooter" bundle:nil];
    [self.tableView registerNib:PlanOptFooterNib forHeaderFooterViewReuseIdentifier:PlanOptFooterID];
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
        //    __block typeof(self) blockSelf = self;
        footer.confirmBlock = ^{
            NSLog(@"tap on confirm btn ");
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




@end
