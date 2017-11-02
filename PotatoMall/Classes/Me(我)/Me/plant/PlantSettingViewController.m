//
//  PlantSettingViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlantSettingViewController.h"

@interface PlantSettingViewController ()

@end

@implementation PlantSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"植保操作";
    [self setupBase];
}

#pragma mark - private methods
- (void)setupBase
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
//    [self reqUnionPlanedInfoWith:params];
}

#pragma mark - requset server
/*
//1.种植信息类型查询 - 请求参数
- (NSDictionary *)Paramstype:(NSString*)type
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = type;
    return params;
}
//1.种植信息类型查询
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
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
}

//2.查询种植信息-请求参数
- (NSDictionary *)userParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    return params;
}


//2.查询种植信息
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
                
                for(int i=0;i<[type2 count];i++){
                    plantmodel *Model =  type2[i];
                    NSString *platSource=[NSString stringWithFormat:@"%@",[data objectForKey:@"platSource"]];
                    if([Model.uid isEqualToString:platSource]){
                        [self.type setText:Model.name];
                    }
                }
                NSLog(@"msg==%@",data);
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
}


//3.植保记录- 请求参数

- (NSDictionary *)userParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    return params;
}



//3.植保记录
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
                self.mlistdata=[plantmodel plantWithDataArray1:data];
                [_mtableview reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
}
*/

@end
