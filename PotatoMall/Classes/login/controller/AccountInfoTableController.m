//
//  AccountInfoTableController.m
//  PotatoMall
//
//  Created by taotao on 02/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "AccountInfoTableController.h"
#import<AVFoundation/AVCaptureDevice.h>
#import<AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSString+Extentsion.h"


@interface AccountInfoTableController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *adrLabel;
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *realNameField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (nonatomic,strong)UIImage *avatarImg;

@end

#define kFirstSectionIdx            0
#define kAvatarRowIdx               1


@implementation AccountInfoTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    if ([model.userType isEqualToString:@"1"]) {
        self.roleLabel.text = @"种植户";
    }else if ([model.userType isEqualToString:@"3"]) {
        self.roleLabel.text = @"采购商";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedAddress:) name:kSelectedCityNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - update UI
- (void)tapPickAvatarBtn
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"相机",@"相册",nil];
    [actionSheet showInView:self.view];
}

- (void)updateAvatarView:(UIImage*)pickedImg
{
//    UIImage *scaledImage = [self image:pickedImg scaleTo:CGSizeMake(30, 30)];
    self.avatarView.image = pickedImg;
}

// scale origin large image to new size
- (UIImage*)image:(UIImage*)orginImage scaleTo:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [orginImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImg;
}

#pragma mark - selectors
- (void)selectedAddress:(NSNotification*)sender
{
    NSString *adr = sender.object;
    HTLog(@"address = %@",adr);
    self.adrLabel.text = adr;
    [UserModelUtil sharedInstance].userModel.address = adr;
    [self.navigationController popToViewController:self animated:YES];
}

- (IBAction)submitUserInfo:(id)sender {
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    if (self.avatarImg == nil) {
    [SVProgressHUD showInfoWithStatus:@"请选择头像"];
    return;
    }else if ([self.nickNameField.text strWithoutSpace].length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入昵称"];
        return;
    }else if ([self.realNameField.text strWithoutSpace].length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入真实姓名"];
        return;
    }else if ([self.idTextField.text strWithoutSpace].length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入身份证"];
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
- (NSDictionary *)userParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[kReqType] = model.userType;
    params[kNickNameKey] = self.nickNameField.text;
    params[kRealNameKey] = self.realNameField.text;
    params[kIdCardKey] = self.idTextField.text;
    params[kSexKey] = @"0";
    params[kProvinceCodeKey] = [NSString stringWithFormat:@"%@",model.proviceId];
    params[kCityCodeKey] = [NSString stringWithFormat:@"%@",model.cityId];
    params[kDistrictCodeKey] = [NSString stringWithFormat:@"%@",model.districtId];
    params[kAddressNameKey] = model.address;
    return params;
}

#pragma mark - private methods
- (UserModel*)updateUserInfoSuccessWith:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSDictionary *userDict = [dict objectForKey:@"obj"];
    UserModel *model = [UserModel mj_objectWithKeyValues:userDict];
    return model;
}

#pragma mark - requset server
- (void)submitUserInfoWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        UIImage *img = self.avatarView.image;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"user/updateUser";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTUserWithURL:reqUrl params:params image:img reqSuccess:^(int status, NSString *msg, id data) {
            
            [SVProgressHUD showSuccessWithStatus:msg];
            if (status == StatusTypSuccess) {
                [self updateUserInfoSuccessWith:data];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
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
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == kFirstSectionIdx) {
        if (indexPath.row == kAvatarRowIdx) {
            [self tapPickAvatarBtn];
        }
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
        [self updateAvatarView:image];
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
        NSString *message = @"宝贝快打开相册让我们选择照片吧";
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
        NSString *message = @"宝贝快打开摄像头让我们拍照吧";
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
