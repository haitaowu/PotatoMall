//
//  MeController.m
//  PotatoMall
//
//  Created by taotao on 25/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "MeController.h"

#import "AppInfoHelper.h"
#import<AVFoundation/AVCaptureDevice.h>
#import<AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LoginViewController.h"
#import "MeMenuCollectionViewCell.h"
#import "NSDictionary+Extension.h"


#define kSaleSectionIndex               0
#define kChargeSectionIndex             3
#define kSettingSectionIndex            4

static NSString *MeMenuCellID = @"MeMenuCellID";


@interface MeController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *menusDataTitle;
@property (nonatomic,strong)NSArray *menusDataImage;
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
    self.menusDataTitle=[NSArray arrayWithObjects:@"采购",@"种植",@"钱包",@"问答",@"设置",nil];
    self.menusDataImage=[NSArray arrayWithObjects:@"purchase",@"plant",@"wallet",@"qa",@"setting",nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.toolbar setBackgroundColor:[UIColor whiteColor]];
    [self updateUserInfoUI];
    NSDictionary *parama=[self whetherUserUnionParams];
    [self whetherUserUnion:parama];
}

- (NSDictionary *)whetherUserUnionParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    return params;
}

#pragma mark - setup UI
- (void)setupTableview
{
    //    UINib *menuCellNib = [UINib nibWithNibName:@"MeMenuCell" bundle:nil];
    //    [self.tableView registerNib:menuCellNib forCellReuseIdentifier:MeMenuCellID];
    //    self.menusData = [AppInfoHelper arrayWithPlistFile:@"MeMenus"];
    //    [self.tableView reloadData];
    
    UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake(88,88); //设置item的大小
    layOut.scrollDirection = UICollectionViewScrollDirectionVertical; //设置布局方式
    layOut.sectionInset = UIEdgeInsetsMake(0, 0,0, 0); //设置距离上 左 下 右
    
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 88, kScreenWidth,220) collectionViewLayout:layOut];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[MeMenuCollectionViewCell class] forCellWithReuseIdentifier:MeMenuCellID];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MeMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MeMenuCellID forIndexPath:indexPath];
    
    NSLog(@"name===%@",[self.menusDataImage objectAtIndex:indexPath.row]);
    [cell.titlelabel setText:[self.menusDataTitle objectAtIndex:indexPath.row]];
    
    if(indexPath.row==0){
            [cell.logoimage setImage:[UIImage imageNamed:@"purchase"]];
    }else{
            [cell.logoimage setImage:[UIImage imageNamed:[self.menusDataImage objectAtIndex:indexPath.row]]];
    }
    
    return cell;
    
    
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==0){
        if ([[UserModelUtil sharedInstance] isUserLogin] == YES) {
            [self performSegueWithIdentifier:@"orderesSegue" sender:nil];
        }else{
            [self showLoginView];
        }
    }
    if(indexPath.row==1){
        if ([[UserModelUtil sharedInstance] isUserLogin] == YES) {
            [self performSegueWithIdentifier:@"plantidentifier" sender:nil];
        }else{
            [self showLoginView];
        }
    }
    if(indexPath.row==4){
        if ([[UserModelUtil sharedInstance] isUserLogin] == YES) {
            [self performSegueWithIdentifier:@"settingSegue" sender:nil];
        }else{
            [self showLoginView];
        }
    }
    
    
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
//        [self.tableView reloadData];
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

- (void)reqUserInfoWithUnionId:(NSString*)unionID
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
     ;
    if (model == nil) {
        return;
    }
    NSDictionary *params;
    if ((unionID == nil) || (unionID.length <= 0)){
       params = [NSDictionary dictionaryWithObjectsAndKeys:model.userId,kUserIdKey,@"2",@"type",nil];
    }else{
        params = [NSDictionary dictionaryWithObjectsAndKeys:model.userId, kUserIdKey,unionID,@"unionId",@"1",@"type",nil];
    }
    NSString *subUrl = @"wallet/findWalletDetail";
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
    [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
        if (status == StatusTypSuccess) {
            NSDictionary *dataDict = [DataUtil dictionaryWithJsonStr:data];
            NSDictionary *modelDict = dataDict[@"obj"];
            //id user
            NSString *availableBalance = [NSString stringWithFormat:@"账户余额:%@元",[modelDict objectForKey:@"availableBalance"]];
            self.moneyLabel.text = availableBalance;
//            [[UserModelUtil sharedInstance] archiveUserModel:model];
        }
    } reqFail:^(int type, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)whetherUserUnion:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        return;
    }else{
        NSString *subUrl = @"/user_union/whetherUserUnion";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            NSString *unionID = nil;
            if (status == StatusTypSuccess) {
                NSDictionary *dataDict = [DataUtil dictionaryWithJsonStr:data];
                NSDictionary *obj = dataDict[@"obj"];
                 unionID = [obj strValueForKey:@"unionId"];
            }
            [self reqUserInfoWithUnionId:unionID];
        } reqFail:^(int type, NSString *msg) {
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
