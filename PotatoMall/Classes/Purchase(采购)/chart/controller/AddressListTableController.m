//
//  AddressListTableController.m
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "AddressListTableController.h"
#import "EditAddressCell.h"
#import "AddAdrFuncCell.h"
#import "NSDictionary+Extension.h"


static NSString *EditAddressCellID = @"EditAddressCellID";
static NSString *AddAdrFuncCellID = @"AddAdrFuncCellID";

@interface AddressListTableController ()
@property(nonatomic,strong) NSArray *dataArray;
@end

@implementation AddressListTableController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController  setToolbarHidden:YES animated:NO];
    UINib *cellNib = [UINib nibWithNibName:@"EditAddressCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:EditAddressCellID];
    
    UINib *funcNib = [UINib nibWithNibName:@"AddAdrFuncCell" bundle:nil];
    [self.tableView registerNib:funcNib forCellReuseIdentifier:AddAdrFuncCellID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reqAdrsData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([segue.identifier isEqualToString:@"addModifySegue"]) {
        AddMofityAdrTableController *destinationControl = [segue destinationViewController];
        if (sender == nil) {
            destinationControl.editType = ReviceAdrTypeAdd;
        }else{
            destinationControl.editType = ReviceAdrTypeModify;
            destinationControl.adrInfo = sender;
        }
    }
}

#pragma mark - private methods
- (void)showAddAddressView
{
    [self performSegueWithIdentifier:@"addModifySegue" sender:nil];
}

- (void)showModiftAddressViewWith:(NSDictionary*)adrInfo
{
    [self performSegueWithIdentifier:@"addModifySegue" sender:adrInfo];
}

//选择城市
- (IBAction)tapChoiceCityBtn:(UIButton*)sender {
//    HTLog(@"hello tapChoiceCityBtn ");
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    UIViewController *control = [storyBoard instantiateViewControllerWithIdentifier:@"ProviceTableController"];
//    [self.navigationController pushViewController:control animated:YES];
}


#pragma mark - requset server
//删除地址
- (void)deleteAdrWithInfo:(NSDictionary*)adrInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    params[kUserIdKey] = model.userId;
    params[@"addressId"] = [adrInfo strValueForKey:@"addressId"];
    NSString *subUrl = @"address/delete";
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
    [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
        if (status == StatusTypSuccess) {
            [SVProgressHUD showSuccessWithStatus:msg];
            [self reqAdrsData];
        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } reqFail:^(int type, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

//设置默认地址
- (void)reqAddDefaultAdr:(NSDictionary*)adrInfo
{
    HTLog(@"设置默认地址");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:adrInfo];
    params[@"isDefault"] = @"1";
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSString *subUrl = @"address/saveOrUpdateUserAddress";
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
    [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
        if (status == StatusTypSuccess) {
            [SVProgressHUD showSuccessWithStatus:msg];
            [self reqAdrsData];
        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } reqFail:^(int type, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)reqAdrsData
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSDictionary *params = @{kUserIdKey:model.userId};
    NSString *subUrl = @"address/list";
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
    [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
        if (status == StatusTypSuccess) {
            [SVProgressHUD showSuccessWithStatus:msg];
            id obj = [DataUtil dictionaryWithJsonStr:data];
            self.dataArray = [obj objectForKey:@"obj"];
        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
        [self.tableView reloadData];
    } reqFail:^(int type, NSString *msg) {
        [self.tableView reloadData];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


#pragma mark - UITableView ---  Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return [self.dataArray count];
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EditAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:EditAddressCellID];
        __block typeof(self) blockSelf = self;
        NSDictionary *adrInfo = [self.dataArray objectAtIndex:indexPath.row];
        cell.adrInfo = adrInfo;
        cell.defaultAdrBlock = ^(id adrInfo) {
            [blockSelf reqAddDefaultAdr:adrInfo];
        };
        
        cell.editAdrBlock = ^(id adrInfo) {
            [blockSelf showModiftAddressViewWith:adrInfo];
        };
        
        cell.deleteAdrBlock = ^(id adrInfo) {
            [blockSelf deleteAdrWithInfo:adrInfo];
        };
        return cell;
    }else{
        AddAdrFuncCell *cell = [tableView dequeueReusableCellWithIdentifier:AddAdrFuncCellID];
        __block typeof(self) blockSelf = self;
        cell.addAddressBlock = ^{
            [blockSelf showAddAddressView];
        };
        return cell;
    }
}

#pragma mark - UITableView --- Table view  delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }else {
        return 80;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}



@end
