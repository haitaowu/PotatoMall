//
//  MeSettingTableController.m
//  PotatoMall
//
//  Created by taotao on 27/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "MeSettingTableController.h"

@interface MeSettingTableController ()

@end

@implementation MeSettingTableController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置"; 
}

#pragma mark - private methods
- (void)userTapLogout
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutSuccessNotification object:nil];
}
#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }else if (section == 1) {
        return 15;
    }else if (section == 2) {
        return 30;
    }else{
        return 0.001;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        [self userTapLogout];
        [[UserModelUtil sharedInstance] archiveUserModel:nil];
        HTLog(@"user tap logout button ");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
