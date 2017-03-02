//
//  DistriTableController.m
//  PotatoMall
//
//  Created by taotao on 02/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "DistriTableController.h"
#import "CityModel.h"

@interface DistriTableController ()
@property (nonatomic,strong)NSMutableArray *citiesArray;

@end

@implementation DistriTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.cityModel != nil) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[kParentIdKey] = self.cityModel.cityId;
        params[kReqType] = @"3";
        [self requestCityDatasWith:params];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.citiesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    CityModel *model = [self.citiesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
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
    CityModel *model = self.citiesArray[indexPath.row];
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@",self.provieModel.name,self.cityModel.name,model.name];
    [UserModelUtil sharedInstance].userModel.districtId = model.cityId;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectedCityNotification object:address];
}

#pragma mark - private methods
- (NSMutableArray*)articlesWithData:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSArray *list = [dict objectForKey:@"obj"];
    NSArray *articles = [CityModel mj_objectArrayWithKeyValuesArray:list];
    return [NSMutableArray arrayWithArray:articles];
}

#pragma mark - requset server
- (void)requestCityDatasWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
//        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"area/list";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD showSuccessWithStatus:msg];
//            [self.tableView.mj_header endRefreshing];
            if (status == StatusTypSuccess) {
                self.citiesArray = [self articlesWithData:data];
//                [self.tableView.mj_footer setHidden:NO];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
//            [self.tableView.mj_header endRefreshing];
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}


@end
