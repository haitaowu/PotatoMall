//
//  PlantSetting0ViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/17.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlantSetting0ViewController.h"
#import "plantmodel.h"
#import "PlantInfoControllerViewController.h"
@interface PlantSetting0ViewController ()

@end

@implementation PlantSetting0ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"植保种植";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)whetherFillPlatInfo:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        
    }else{
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/user_union/whetherUserUnion";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
                data=[plantmodel plantWithData:data];
                
                if([[data objectForKey:@"status"] isEqualToString:@"0"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意"
                                                                    message:@"您的种植信息还没有填写完成，请填写完善您的种植信息后再申请植保计划"
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"确认",nil];
                    alert.tag=1;
                    [alert show];
                }
                
                NSLog(@"data==%@",[data objectForKey:@"status"]);
                
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
    
    
    
    
}

//按钮点击事件的代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clickButtonAtIndex:%d",(int)buttonIndex);
    
    if(alertView.tag==0){
        if((int)buttonIndex==1){
            NSDictionary *parama=[self whetherFillPlatInfoParams];
            [self whetherFillPlatInfo:parama];
        }
    }
    if(alertView.tag==1){
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me"bundle:nil];
        PlantInfoControllerViewController *storVC = [story instantiateViewControllerWithIdentifier:@"plantinfoidentifier"];
        [self.navigationController pushViewController:storVC animated:YES];
        
//        PlantInfoControllerViewController *_PlantInfoControllerViewController= [[PlantInfoControllerViewController alloc] init];
//        [self.navigationController pushViewController:_PlantInfoControllerViewController animated:YES];
    }
    //index为-1则是取消，
}




- (NSDictionary *)whetherFillPlatInfoParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    return params;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)peoplecommit:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意"
                                                    message:@"一旦以个体种植户身份获得植保计划之后，将在该种植期间内无法挤入任何联合体！您是否仍要申请个体植保计划"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认",nil];
    alert.tag=0;
    [alert show];
    
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
