//
//  PlantUserViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlantUserViewController.h"
#import "plantmodel.h"
#import "plantuserTableViewCell.h"
@interface PlantUserViewController ()

@end

@implementation PlantUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_mtableview registerNib:[UINib nibWithNibName:@"plantuserTableViewCell" bundle:nil] forCellReuseIdentifier:@"peopleIdentifier"];
    
    NSDictionary *findUnionUsersParams=[self findUnionUsersParams];
    [self findUnionUsers:findUnionUsersParams];
    
    self.title=@"联合体成员";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加成员" style:UIBarButtonItemStylePlain target:self action:@selector(addpeople:)];
    
    self.managebutton.layer.borderColor = [UIColor blackColor].CGColor;
    self.managebutton.layer.borderWidth = 1;
    self.managebutton.layer.masksToBounds = YES;
    self.managebutton.layer.cornerRadius = 5;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)managebuttonclick:(id)sender {
     [SVProgressHUD showErrorWithStatus:@"您不是管理员,无法操作"];
}

- (void)addpeople:(id)sender
{
      [SVProgressHUD showErrorWithStatus:@"您不是管理员,无法操作"];
}


- (NSDictionary *)findUnionUsersParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    return params;
}

- (void)findUnionUsers:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        
    }else{
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/user_union/findUnionUsers";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
                mlistdata=[plantmodel plantWithDataArray:data];
                
                self.numlabel0.text=[NSString stringWithFormat:@"(共%lu名)",[mlistdata count]];
                
                [_mtableview reloadData];
                
//                NSLog(@"data==%@",[[data objectAtIndex:0]objectForKey:@"userName"]);
//
//
//                NSURL *photourl = [NSURL URLWithString:[[data objectAtIndex:0]objectForKey:@"headPic"]];
//                //url请求实在UI主线程中进行的
//                UIImage *images = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl]];
//                _logoimage.image = images;
//
//                [_titlelabel setText:[[data objectAtIndex:0]objectForKey:@"userName"]];
//                _cellphone.text=[[data objectAtIndex:0]objectForKey:@"phone"];
                
    
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mlistdata count];
}

//1 创建人 2 管理员 3普通用户
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString  *listCellID = @"peopleIdentifier";
    plantuserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    plantmodel *model=[mlistdata objectAtIndex:indexPath.row];
    cell.titlelabel.text=model.userName;
    cell.infolabel.text=model.phone;
    if([model.unionType isEqualToString:@"1"]){
        [cell.button setTitle:@"创建人" forState:UIControlStateNormal];
    }
    if([model.unionType isEqualToString:@"2"]){
        [cell.button setTitle:@"管理员" forState:UIControlStateNormal];
    }
    if([model.unionType isEqualToString:@"3"]){
        [cell.button setTitle:@"普通用户" forState:UIControlStateNormal];
        [cell.button setBackgroundColor:[UIColor redColor]];
    }
    
    
    NSURL *photourl = [NSURL URLWithString:model.headPic];
    //url请求实在UI主线程中进行的
    UIImage *images = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl]];
    cell.logoimage.image = images;
    
    return cell;
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
