//
//  AccountTableController.m
//  PotatoMall
//
//  Created by taotao on 27/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "AccountTableController.h"
#import "NSString+Extentsion.h"
#import<AVFoundation/AVCaptureDevice.h>
#import<AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface AccountTableController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end
/**性别(0保密1男2女)*/
@implementation AccountTableController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - setup UI
- (void)setupUI
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSString *phone = model.phone;
    phone = [phone securityPhone];
    self.phoneLabel.text = phone;
    
}
#pragma mark - private methods
#pragma mark - requset server

#pragma mark - UITableView --- Table view  delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
