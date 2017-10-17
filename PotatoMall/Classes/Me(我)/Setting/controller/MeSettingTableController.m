//
//  MeSettingTableController.m
//  PotatoMall
//
//  Created by taotao on 27/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "MeSettingTableController.h"

@interface MeSettingTableController ()<UIActionSheetDelegate>

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
    [SVProgressHUD showSuccessWithStatus:@"退出成功"];
     [[UserModelUtil sharedInstance] archiveUserModel:nil];
    [self.navigationController popViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutSuccessNotification object:nil];
}

//show recie address
- (void)showAddressListView
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Purchase" bundle:nil];
    UIViewController *control = [storyBoard instantiateViewControllerWithIdentifier:@"AddressListTableController"];
    [self.navigationController pushViewController:control animated:YES];
}
- (void)pourTrash
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定要清除缓存" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

//清除SDWebimage的图片缓存
- (void)clearSdWebCache
{
    [[SDImageCache sharedImageCache] clearDisk];
    [SVProgressHUD showSuccessWithStatus:@"清除成功！"];
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
       
        HTLog(@"user tap logout button ");
    }else if ((indexPath.section == 0) && (indexPath.row == 1)) {
        [self showAddressListView];
    }else if ((indexPath.section == 0) && (indexPath.row == 2)) {
        [self pourTrash];
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

#pragma mark - UIAction sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            HTLog(@"confirm....");
            [self clearSdWebCache];
            break;
        case 1:
            HTLog(@"cancel...");
            break;
        default:
            break;
    }
}

@end
