//
//  UnionedPlanOptStateController.m
//  PotatoMall
//
//  Created by taotao on 2017/11/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "UnionedPlanOptStateController.h"

#define kAdminNoPlanedSectionIdx             0
#define kPlaningSectionIdx                   1
#define kUserNoPlanedSectionIdx              2

@interface UnionedPlanOptStateController ()

@end

@implementation UnionedPlanOptStateController

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - private methods
/*0暂无模板 1正在审核 2审核通过 3 申请被驳回 4 该用户以个体户进行植保计划，无法加入联合体*/
- (BOOL)isPlaned
{
    if ([self.planState isEqualToString:@"2"]) {
        return YES;
    }else{
        return NO;
    }
}

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
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kAdminNoPlanedSectionIdx) {
        if (indexPath.row == 0) {
            return 120;
        }else{
            return 250;
        }
    }else if (indexPath.section == kPlaningSectionIdx) {
        return kScreenHeight;
    }else{
        return kScreenHeight;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kAdminNoPlanedSectionIdx) {
        if ([[UserModelUtil sharedInstance] isAdminRole]) {
            if ([self isReviewing] == YES) {
                return 0;
            }else{
                return 2;
            }
        }else{
            return 0;
        }
    }else if (section == kPlaningSectionIdx) {
        if ([self isReviewing] == YES) {
            return 1;
        }else{
            return 0;
        }
    }else{
        if ([[UserModelUtil sharedInstance] isAdminRole] == NO) {
            if ([self isReviewing] == NO) {
                return 1;
            }else{
                return 0;
            }
        }else{
            return 0;
        }
    }
}




@end
