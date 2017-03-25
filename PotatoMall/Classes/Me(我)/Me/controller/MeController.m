//
//  MeController.m
//  PotatoMall
//
//  Created by taotao on 25/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "MeController.h"
#import "MeMenuCell.h"
#import "AppInfoHelper.h"
#import<AVFoundation/AVCaptureDevice.h>
#import<AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LoginViewController.h"

#define kSaleSectionIndex               0
#define kChargeSectionIndex             3
#define kSettingSectionIndex            4

static NSString *MeMenuCellID = @"MeMenuCellID";


@interface MeController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *menusData;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic,strong)UIImage *avatarImg;

@end

@implementation MeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.toolbar setBackgroundColor:[UIColor whiteColor]];
    [self updateUserInfoUI];
}

#pragma mark - setup UI 
- (void)setupTableview
{
    UINib *menuCellNib = [UINib nibWithNibName:@"MeMenuCell" bundle:nil];
    [self.tableView registerNib:menuCellNib forCellReuseIdentifier:MeMenuCellID];
    self.menusData = [AppInfoHelper arrayWithPlistFile:@"MeMenus"];
    [self.tableView reloadData];
}

- (void)updateUserInfoUI
{
    [[UserModelUtil sharedInstance] avatarImageWithBlock:^(UIImage *img) {
        self.avatarView.image = img;
    }];
    if ([[UserModelUtil sharedInstance] isUserLogin] == YES) {
        UserModel *model = [UserModelUtil sharedInstance].userModel;
        NSString *nickName = model.nickName;
        self.roleLabel.text = [UserModelUtil userRoleWithType:model.userType];
        NSString *roleTitle ;
        if ((nickName.length <= 0) || (nickName == nil)) {
            roleTitle = model.phone;
        }else{
            roleTitle = model.nickName;
        }
        self.nickNameLabel.text = [NSString stringWithFormat:@"%@",roleTitle];
    }else{
        self.nickNameLabel.text = @"游客";
        self.roleLabel.text = @"";
    }
}

#pragma mark - requset server
- (void)submitUserAvtarImage:(UIImage *)avatarImg
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        UserModel *model = [UserModelUtil sharedInstance].userModel;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[kUserIdKey] = model.userId;
        NSString *subUrl = @"user/updateUser";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTUserWithURL:reqUrl params:params image:avatarImg reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD showSuccessWithStatus:msg];
            if (status == StatusTypSuccess) {
                UserModel *model = [UserModelUtil sharedInstance].userModel;
                self.avatarView.image = avatarImg;
                model.avatarData = UIImagePNGRepresentation(avatarImg);
                [[UserModelUtil sharedInstance] archiveUserModel:model];
            }else{
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

#pragma mark - selectors
- (IBAction)tapEditInfo:(id)sender {
    if ([[UserModelUtil sharedInstance] isUserLogin] == YES) {
        [self performSegueWithIdentifier:@"meInfoSegue" sender:nil];
    }else{
        [self showLoginView];
    }
}

- (IBAction)tapEditAvatarBtn:(id)sender {
    if ([[UserModelUtil sharedInstance] isUserLogin] == YES) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"相机",@"相册",nil];
        [actionSheet showInView:self.view];
    }else{
        [self showLoginView];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menusData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:MeMenuCellID];
    NSDictionary *menuData = self.menusData[indexPath.section];
    [cell setMenuData:menuData indexPath:indexPath];
    return cell;
}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == kSaleSectionIndex) {
//        return 16;
//    }else if (section == kChargeSectionIndex) {
//        return 16;
//    }else if (section == kSettingSectionIndex) {
    return 16;
//    }else{
//        return 0.001;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[UserModelUtil sharedInstance] isUserLogin] == NO) {
        [self showLoginView];
    }else{
        NSDictionary *menuData = self.menusData[indexPath.section];
        NSString *segue = [menuData objectForKey:kSegueKey];
        [self performSegueWithIdentifier:segue sender:nil];
    }
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
            HTLog(@"相机");
            [self pickImageByCamera];
            break;
        case 1:
            HTLog(@"相册");
            [self pickImageByLibrary];
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    HTLog(@"didFinishPickingImage");
    [self dismissViewControllerAnimated:YES completion:^{
        self.avatarImg = image;
        [self submitUserAvtarImage:image];
    }];
}


#pragma mark - private pick image methods
- (void)pickImageByLibrary
{
    ALAuthorizationStatus authorStatus = [ALAssetsLibrary authorizationStatus];
    if (authorStatus == ALAuthorizationStatusDenied ||UIImagePickerControllerSourceTypeCamera == ALAuthorizationStatusNotDetermined) {
        NSString *message = @"未获取授权使用照片";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未获取授权使用照片" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.tabBarController presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }else{
        HTLog(@"相册 是 不可用的");
    }
}

- (void)pickImageByCamera
{
    AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
    if (authorStatus == AVAuthorizationStatusDenied ||UIImagePickerControllerSourceTypeCamera == AVAuthorizationStatusNotDetermined) {
        NSString *message = @"未获取授权使用相机";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未获取授权使用相机" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }else{
        HTLog(@"camera   available ...");
    }
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.tabBarController presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }else{
        HTLog(@"相机 是 不可用的");
    }
}


@end
