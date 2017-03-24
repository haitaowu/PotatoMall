//
//  CityTableController.m
//  PotatoMall
//
//  Created by taotao on 02/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "CityTableController.h"
#import "CityModel.h"
#import "DistriTableController.h"

@interface CityTableController ()
@property (nonatomic,strong)NSMutableArray *citiesArray;

@end

@implementation CityTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.model != nil) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[kParentIdKey] = self.model.cityId;
        params[kReqType] = @"2";
        [self requestCityDatasWith:params];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"distriSegue"]) {
        DistriTableController *destinationControl = (DistriTableController*)[segue destinationViewController];
        destinationControl.cityModel = sender;
        destinationControl.provieModel = self.model;
    }
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
    [self performSegueWithIdentifier:@"distriSegue" sender:model];
    [UserModelUtil sharedInstance].userModel.cityId = model.cityId;
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
//            [SVProgressHUD showSuccessWithStatus:msg];
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
