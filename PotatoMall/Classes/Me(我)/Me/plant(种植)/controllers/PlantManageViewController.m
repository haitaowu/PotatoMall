//
//  PlantManageViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/9.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlantManageViewController.h"
#import "plantmodel.h"
#import "PlantPlanTableViewController.h"
#import "PlantInfoControllerViewController.h"
#import "UnionedMembersController.h"
#import "plantlistViewController.h"
#import "plantlistViewController.h"
#import "PlantInfomationTableViewController.h"
#import "UnionedPlanApplyController.h"
#import "UnionedMembersController.h"
#import "UnionedBillsController.h"
#import "UnionRemitController.h"


@interface PlantManageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mtableview;

@end

@implementation PlantManageViewController
#pragma mark - Overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"合作社管理";
    tabledata=[[NSMutableArray alloc]initWithObjects:@"合作社植保计划",@"合作社信息",@"合作社成员",@"合作社订单", nil];
    
    NSDictionary *parama=[self detailUserUnionaParams];
    [self detailUserUnion:parama];
    
    NSDictionary *findWalletDetailParams=[self findWalletDetailParams];
    [self findWalletDetail:findWalletDetailParams];
    
    self.mtableview.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.
    
    NSString *reqData = @"3393FE5EB1F259585EC6FE78012ADD20EB26764C0172F2DB0E1FFB2152C3184C";
    NSDictionary *reqDict = [DataUtil dictionaryWithJsonStr:reqData];
        NSLog(@"request data = %@",reqDict);
    
    NSString *responseData = @"16921C1118056849E252C543014FD7A0387EFDCE247F575F1184EE2C438A1FA807DB3981E213FD44895025DC78516914473709527B5E2C994ACF5222335E408CC984CDF3CB24B605E62071EEB977ECBA0C31E3FFF786DDC9ED376273B6A5B4BE6E8D6D7E0497DD1A860DE158E43399DE5ADB4173AD76FDB9FA56D0C0644AC5C5A2C593F9AC4D8412159689382DA184B6A59B19C9019EAD1358689E231A874015DA6CFAFF107E1A2C5D26F4F6E1FD9A8E45F9C512D55D78356397B50ECAB08681473709527B5E2C994ACF5222335E408C6D160FDF41AF8791165C6C4AC8CDFE968C468E3873F56A2404F71780D782E3CA864EF8FB31E37CFFCCAF97930BD752D101A88E7A508909028134E04C75E1561086E1DD89637FBEB44F8DE3B35058F57A071B8ED1CDF3B399A9C5D716525AAF8D91D8F298DB35C3A9980C3310A292139204203DD3BF774C456D4A5354199646299EEAC5A2BDF725EBFB8ECFFE49FE9F9D6E706C712EA467CFEB4AB570E4B61F77901D90B8CD2E0509CABC5457C34056C4DB3FD411128ABB26D9FFCF39BDDDB82E38101B1094DB94C57B1384D191A98EBF2D70FAE5C663DC6E2058EFC68C6396D83AF73AE03D362D9F9CACE865CD915FC1E891255A6F63AFA6E2CAFAA8A160A14A6A6E140B501FD76B0A44CA9FD6A2464323D98831AB2702FDFCEE26A5C2677A36CA4466E6B3CEF9783C3FCDD8434BA2D1B610CB23235EA082115BFEA7CD37DC07074549A64F27258917B9E3A51DF0AFD50A64AA3ADFF108514D796A31510257690AED1BB7A612FD6FFA28C85505DBA8C91E8C3D9164B1EC5696B4C585AC068F277588119C114D7FB24C7B61F11488FBC864C48B3752451777FC5B33A4DE115C24890BB7B2C83FFD700F1E2A61C9647F01E2A47604CDB73A016A1473A809BF8A6EACD258D3930E82DBE9B21872287B4A5D53922737B3C1CFA1DE3A37E0C3EFBB6620E4421A4E6205D835637C8E3B65DC6C6C4AA5D696EAF6A68120F4D70B3FBED0A09D64CAF9C6AB35BE1C824DD9F2DB916C48C1E8883E2B4A5C7770C9A60AD065BA769621D11302D839C07C50BD5CC63C948FEE2B4C386175F4E7F2574DA6D0F485CE6226189B7BBB5C48E484D9C04355B48540C45505658C0CC8362EC9B71CDFCF8A663DEFF56C344194FA866486239F446172CC1E051CD1A053A6BC34F98A61773D172914E23E432F265C5BB3692A8C51E30A559B0E5E30F873ECF190897AE05F9301E955F309EA60BBCBFDF85CF7CAC494F70D15B85C98A47621C189D9D9A712D5041ACCFB9AC83807E161089266DFFEE9DBCCB91E6EA7A2FB697D0D69C69CA89ACB0E5A649E4D6DA332C859316B5FFF075C988790F0F8FACE5DB9270D732FF117C334437D0C9E26EDDDB0404DE65794080EE28E9AEC47C5AA9A110169B05E83E95FAB9F7BC69DBE2308886E8E61675EA7D9FBE9C026CDC725F72A1687FAAB";
    NSDictionary *responseDict = [DataUtil dictionaryWithJsonStr:responseData];
    NSLog(@"response data = %@",responseDict);
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [self.navigationController  setToolbarHidden:YES animated:YES];
    [self.navigationController.toolbar setBackgroundColor:[UIColor whiteColor]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"plantplan"]) {
        PlantPlanTableViewController *vc = segue.destinationViewController;
        vc.unionId =self.unionId;
        vc.createDate=time;
    }else if ([segue.identifier isEqualToString:@"planinfo"]) {
        PlantInfoControllerViewController *vc = segue.destinationViewController;
        vc.canclick=@"1";
    }else if ([segue.identifier isEqualToString:@"plantinfomation"]) {
        PlantInfomationTableViewController *vc = segue.destinationViewController;
        vc.unionId =self.unionId;
    }else if ([segue.identifier isEqualToString:@"unionedPlanApplySegue"]) {
        UnionedPlanApplyController *vc = segue.destinationViewController;
        vc.unionId = self.unionId;
        vc.planState = self.planState;
    }else if ([segue.identifier isEqualToString:@"membersSegue"]) {
        UnionedMembersController *vc = segue.destinationViewController;
        vc.unionId = self.unionId;
    }else if ([segue.identifier isEqualToString:@"billsSegue"]) {
        UnionedBillsController *vc = segue.destinationViewController;
        vc.unionId = self.unionId;
    }else if ([segue.identifier isEqualToString:@"unionRemitSegue"]) {
        UnionRemitController *vc = segue.destinationViewController;
        vc.unionId = self.unionId;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Privates
/*0暂无模板 1正在审核 2审核通过 3 申请被驳回 4 该用户以个体户进行植保计划，无法加入联合体*/
- (BOOL)isPlaned
{
    if ([self.planState isEqualToString:@"2"]) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)isReviewing
{
    if ([self.planState isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - requset server
- (void)findWalletDetail:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/wallet/findWalletDetail";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
               [SVProgressHUD dismiss];
                data=[plantmodel plantWithData:data];
                [self.mdetail setText:[NSString stringWithFormat:@"联合体余额：%@",[data objectForKey:@"availableBalance"]]];
//                NSLog(@"findWalletDetail==%@",data);
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

- (void)detailUserUnion:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/user_union/detailUserUnion";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD dismiss];
                data=[plantmodel plantWithData:data];
                [self.mtitle setText:[data objectForKey:@"unionName"]];
                time=[data objectForKey:@"createDate"];
//                NSLog(@"msg==%@",data);
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

- (NSDictionary *)detailUserUnionaParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    return params;
}

- (NSDictionary *)findWalletDetailParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"unionId"] = self.unionId;
    params[@"type"] = @"1";
    return params;
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tabledata count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIndetifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    cell.textLabel.text = [tabledata objectAtIndex:indexPath.row];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    return cell;
    
}

#pragma mark - UITableView --- Table view  delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
/*0暂无模板 1正在审核 2审核通过 3 申请被驳回 4 该用户以个体户进行植保计划，无法加入联合体*/
        if ([self.planState isEqualToString:@"1"]) {
            [self performSegueWithIdentifier:@"planReviewSegue" sender:nil];
        }else if ([self.planState isEqualToString:@"2"]) {
            [self performSegueWithIdentifier:@"plantplan" sender:nil];
        }else{
            [self performSegueWithIdentifier:@"unionedPlanApplySegue" sender:nil];
        }
    }
    if (indexPath.row==1) {
        [self performSegueWithIdentifier:@"plantinfomation" sender:nil];
    }
    
    if (indexPath.row==2) {
        [self performSegueWithIdentifier:@"membersSegue" sender:nil];
//        UnionedMembersController *_UnionedMembersController = [[UnionedMembersController alloc] init];
////        _PlanWebViewViewController.murl = murl;
//        _UnionedMembersController.unionId =self.unionId;
//        [self.navigationController pushViewController:_UnionedMembersController animated:YES];
    }
    
    if (indexPath.row==3) {
        plantlistViewController *_plantlistViewController = [[plantlistViewController alloc] init];
        _plantlistViewController.unionId = self.unionId;
        [self.navigationController pushViewController:_plantlistViewController animated:YES];
    }
}



 

@end
