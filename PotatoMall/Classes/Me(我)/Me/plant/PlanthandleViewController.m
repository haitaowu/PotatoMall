//
//  PlanthandleViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/20.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlanthandleViewController.h"
#import "plantmodel.h"
#import "PlantListTableCell1TableViewCell.h"
#import "PlanWebViewViewController.h"
#import "NSString+Extentsion.h"
#import<AVFoundation/AVCaptureDevice.h>
#import<AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PlantDoneViewController.h"
@interface PlanthandleViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation PlanthandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"植保操作";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"已完成记录" style:UIBarButtonItemStylePlain target:self action:@selector(donelist:)];
    
    [_mtableview registerNib:[UINib nibWithNibName:@"PlantListTableCell1TableViewCell" bundle:nil] forCellReuseIdentifier:@"listIdentifier1"];
    
    NSDictionary *parama=[self userParams];
    [self detailUserPlat:parama];
    [self findUserPlatRecord:parama];
    state=false;
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)donelist:(UIButton *)sender{
    
    PlantDoneViewController *_PlantDoneViewController = [[PlantDoneViewController alloc] init];
    _PlantDoneViewController.unionId = self.unionId;
    [self.navigationController pushViewController:_PlantDoneViewController animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self findSysDictByType:[self Paramstype:@"1"]];
    [self findSysDictByType:[self Paramstype:@"2"]];
    [self findSysDictByType:[self Paramstype:@"3"]];
    
}


//查询字典
#pragma mark - requset server
- (void)findSysDictByType:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        
    }else{
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/system/findSysDictByType";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
                
                if([[params objectForKey:@"type"]isEqualToString:@"1"]){
                    type0=[plantmodel plantWithDataArray:data];
                }
                if([[params objectForKey:@"type"]isEqualToString:@"2"]){
                    type1=[plantmodel plantWithDataArray:data];
                }
                if([[params objectForKey:@"type"]isEqualToString:@"3"]){
                    type2=[plantmodel plantWithDataArray:data];
                }
                
                
                //                NSLog(@"type0==%@",type0);
                
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
    
    
    
    
}


- (NSDictionary *)Paramstype:(NSString*)type
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = type;
    return params;
}


- (NSDictionary *)userParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    return params;
}


- (void)detailUserPlat:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        
    }else{
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/user/detailUserPlat";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
                
                data=[plantmodel plantWithData:data];
                [self.address setText:[data objectForKey:@"platAddress"]];
                [self.arealabel setText:[NSString stringWithFormat:@"%@亩",[data objectForKey:@"platArea"]]];
                
//                for(int i=0;i<[type0 count];i++){
//                    plantmodel *Model =  type0[i];
//                    NSString *cropName=[NSString stringWithFormat:@"%@",[data objectForKey:@"cropName"]];
//
//                    if([Model.uid isEqualToString:cropName]){
//
//                        [self.lastmodelbutton setTitle:Model.name forState:UIControlStateNormal];
//                    }
//                }
//
//                for(int i=0;i<[type1 count];i++){
//                    plantmodel *Model =  type1[i];
//                    NSString *platType=[NSString stringWithFormat:@"%@",[data objectForKey:@"platType"]];
//
//                    if([Model.uid isEqualToString:platType]){
//
//                        [self.zhongsubutton setTitle:Model.name forState:UIControlStateNormal];
//                    }
//                }
                
                for(int i=0;i<[type2 count];i++){
                    plantmodel *Model =  type2[i];
                    NSString *platSource=[NSString stringWithFormat:@"%@",[data objectForKey:@"platSource"]];
                    
                    
                    if([Model.uid isEqualToString:platSource]){
                        
                        [self.type setText:Model.name];
                    }
                }
                //
                
                NSLog(@"msg==%@",data);
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
    
    
    
    
}


- (void)findUserPlatRecord:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        
    }else{
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/plat/findUserPlatRecord";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
                
                
                
                mlistdata=[plantmodel plantWithDataArray1:data];
                NSLog(@"data==%@",mlistdata);
                
                
                
                [_mtableview reloadData];
                
                
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
    
    
    
    
}
- (IBAction)openbuttonclick:(id)sender {
    if(!state){
        [_mtableview setHidden:YES];
        state=true;
        [openbutton setTitle:@"展开" forState:UIControlStateNormal];
        return;
    }else{
        [openbutton setTitle:@"收起" forState:UIControlStateNormal];
        [_mtableview setHidden:NO];
        state=false;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mlistdata count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString  *listCellID = @"listIdentifier1";
    PlantListTableCell1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    plantmodel *model=[mlistdata objectAtIndex:indexPath.row];
    cell.title.text=model.platDate;
    cell.content.text=model.catalogName;
    murl=model.helpUrl;
    [cell.cellclickbutton addTarget:self action:@selector(cellclick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    

}
- (IBAction)chooseimage:(id)sender {
    [self tapPickAvatarBtn];
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
        [uploadimage setImage:image forState:UIControlStateNormal];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    HTLog(@"imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}



- (void)cellclick:(UIButton *)sender{
    
    PlanWebViewViewController *_PlanWebViewViewController = [[PlanWebViewViewController alloc] init];
    _PlanWebViewViewController.murl = murl;
    [self.navigationController pushViewController:_PlanWebViewViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
