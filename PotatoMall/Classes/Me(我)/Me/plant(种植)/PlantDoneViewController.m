//
//  PlantDoneViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/21.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlantDoneViewController.h"
#import "plantdoneTableViewCell.h"
#import "plantmodel.h"
@interface PlantDoneViewController ()

@end

@implementation PlantDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [_mtableview registerNib:[UINib nibWithNibName:@"plantdoneTableViewCell" bundle:nil] forCellReuseIdentifier:@"donelist"];
    [self.mtableview reloadData];
    
    NSDictionary *parama=[self userParams];
    [self findUserPlatRecord:parama];
    
    // Do any additional setup after loading the view from its nib.
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
                
                
                
                self.mlistdata=[plantmodel plantWithDataArray1:data];
//                NSLog(@"data==%@",mlistdata);
                
                
                
                [_mtableview reloadData];
                
                
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
    
    
    
    
}

- (NSDictionary *)userParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    return params;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    return 165;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mlistdata count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString  *listCellID = @"donelist";
    plantdoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
//    plantmodel *model=[mlistdata objectAtIndex:indexPath.row];
//    cell.title.text=model.platDate;
//    cell.content.text=model.catalogName;
//    murl=model.helpUrl;
//    [cell.cellclickbutton addTarget:self action:@selector(cellclick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
    
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
