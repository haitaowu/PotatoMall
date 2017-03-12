//
//  MeInfoTableController.m
//  PotatoMall
//
//  Created by taotao on 27/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "MeInfoTableController.h"
#import "NSString+Extentsion.h"
#import<AVFoundation/AVCaptureDevice.h>
#import<AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface MeInfoTableController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UITextField *realNameField;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UIButton *maleStateView;
@property (weak, nonatomic) IBOutlet UIButton *femaleStateView;
@property (weak, nonatomic) IBOutlet UILabel *adrLabel;
@property (nonatomic,strong)UIImage *avatarImg;

@property (nonatomic,strong)UserModel *tmpModel;

@end
/**性别(0保密1男2女)*/
@implementation MeInfoTableController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedAddress:) name:kSelectedCityNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUserInfoUI];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - setup UI
- (void)updateUserInfoUI
{
    [[UserModelUtil sharedInstance] avatarImageWithBlock:^(UIImage *img) {
        self.avatarView.image = img;
        self.tmpModel.avatarData = UIImagePNGRepresentation(img);
    }];
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    self.roleLabel.text = [UserModelUtil userRoleWithType:model.userType];
    self.realNameField.text =  model.realName;
    self.nickNameField.text = model.nickName;
    self.adrLabel.text = model.address;
    
    if ([model.sex isEqualToString:@"1"]) {
        self.maleStateView.selected = YES;
    }else if ([model.sex isEqualToString:@"2"]) {
        self.femaleStateView.selected = YES;
    }
    
}

- (void)tapPickAvatarBtn
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"相机",@"相册",nil];
    [actionSheet showInView:self.view];
}


#pragma mark - selectors
- (IBAction)tapSexStateView:(UIButton*)sender {
    NSInteger sexState = sender.tag;
    if(sender.selected == NO){
        if (sexState == 1) {
            self.maleStateView.selected = YES;
            self.femaleStateView.selected = NO;
        }else{
            self.maleStateView.selected = NO;
            self.femaleStateView.selected = YES;
        }
    }
}

#pragma mark - selectors
- (void)selectedAddress:(NSNotification*)sender
{
    NSString *adr = sender.object;
    self.adrLabel.text = adr;
    [UserModelUtil sharedInstance].userModel.address = adr;
    [self.navigationController popToViewController:self animated:YES];
}

- (IBAction)submitUserInfo:(id)sender {
    UserModel *model = [UserModelUtil sharedInstance].userModel;
//    if (self.avatarImg == nil) {
//        [SVProgressHUD showInfoWithStatus:@"请选择头像"];
//        return;
//    }else
    if ([self.nickNameField.text strWithoutSpace].length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入昵称"];
        return;
    }else if ([self.realNameField.text strWithoutSpace].length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入真实姓名"];
        return;
    }else if ((model.address == nil)||(model.address.length <= 0)) {
        [SVProgressHUD showInfoWithStatus:@"请选择地址"];
        return;
    }else{
        NSDictionary *params = [self userParams];
        [self submitUserInfoWith:params];
    }
}


#pragma mark - private methods
- (UserModel*)updateUserInfoSuccessWith:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSDictionary *userDict = [dict objectForKey:@"obj"];
    UserModel *model = [UserModel mj_objectWithKeyValues:userDict];
    model.avatarData = UIImagePNGRepresentation(self.avatarView.image);
    [[UserModelUtil sharedInstance] archiveUserModel:model];
    return model;
}


- (NSDictionary *)userParams
{
    NSString *sex = @"0";
    if (self.maleStateView.selected == YES) {
        sex = @"1";
    }else if (self.maleStateView.selected == YES) {
        sex = @"2";
    }
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[kReqType] = model.userType;
    params[kNickNameKey] = self.nickNameField.text;
    params[kRealNameKey] = self.realNameField.text;
    params[kSexKey] = sex;
    params[kProvinceCodeKey] = [NSString stringWithFormat:@"%@",model.proviceId];
    params[kCityCodeKey] = [NSString stringWithFormat:@"%@",model.cityId];
    params[kDistrictCodeKey] = [NSString stringWithFormat:@"%@",model.districtId];
    params[kAddressNameKey] = model.address;
    return params;
}



#pragma mark - requset server
- (void)submitUserInfoWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        UIImage *img = self.avatarImg;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"user/updateUser";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTUserWithURL:reqUrl params:params image:img reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD showSuccessWithStatus:msg];
            if (status == StatusTypSuccess) {
                [self updateUserInfoSuccessWith:data];
            }else{
                [[UserModelUtil sharedInstance] archiveUserModel:self.tmpModel];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            [[UserModelUtil sharedInstance] archiveUserModel:self.tmpModel];
        }];
    }
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 16;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self tapPickAvatarBtn];
    }else if ((indexPath.section == 2) && (indexPath.row == 1)) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *control = [storyBoard instantiateViewControllerWithIdentifier:@"ProviceTableController"];
        [self.navigationController pushViewController:control animated:YES];
    }else if ((indexPath.section == 3) && (indexPath.row == 0)) {
        [self submitUserInfo:nil];
    }
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
        self.avatarImg= image;
        self.avatarView.image = image;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    HTLog(@"imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - UIScorllView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
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
        [self presentViewController:imagePicker animated:YES completion:^{
            
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
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }else{
        HTLog(@"相机 是 不可用的");
    }
}

@end
