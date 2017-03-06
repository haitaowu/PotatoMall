//
//  ChartTableController.m
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "ChartTableController.h"
#import "ChartCell.h"
#import "ChartSectionHeader.h"
#import "GoodsModel.h"
#import "HTCalculatorToolBar.h"


static NSString *ChartCellID = @"ChartCell";
static NSString *HeaderID = @"HeaderID";

@interface ChartTableController ()
@property (nonatomic,strong)NSMutableArray *goodsArray;
@end

@implementation ChartTableController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self reqGoodsData];
    [self setupNavToolbar];
    [self.navigationController  setToolbarHidden:NO animated:YES];
}

#pragma mark - setup UI 
- (void)setupNavToolbar
{
    [self.navigationController  setToolbarHidden:NO animated:YES];
    UIView *toolbar = [HTCalculatorToolBar customToolBarWithAllBlock:^{
        NSLog(@"selected all products ");
    } unSelectBlock:^{
        NSLog(@"unselected all products ");
    } calculatorBlock:^{
        NSLog(@"calculator products price ");
    }];
    
    CGRect frame = self.navigationController.toolbar.frame;
    NSLog(@"frame from %@",NSStringFromCGRect(frame));
    toolbar.frame = frame;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    self.toolbarItems = @[barItem];
}

- (void)setupTableView
{
    UINib *cellNib = [UINib nibWithNibName:@"ChartCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:ChartCellID];
    
    UINib *headerNib = [UINib nibWithNibName:@"ChartSectionHeader" bundle:nil];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:HeaderID];
}

#pragma mark - requset server
- (void)reqGoodsData
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        id userId = [UserModelUtil sharedInstance].userModel.userId;
        params[kUserIdKey] = userId;
        NSString *subUrl = @"cart/goCart";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD showInfoWithStatus:msg];
            if (status == StatusTypSuccess) {
                self.goodsArray =  [GoodsModel goodsWithData:data];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

#pragma mark - UITableView --- Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.goodsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:ChartCellID];
    GoodsModel *model = self.goodsArray[indexPath.row];
    [cell setModel:model];
    cell.deleteBlock = ^(GoodsModel *model){
        [self.goodsArray removeObject:model];
        [self.tableView reloadData];
    };
    return cell;
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ChartSectionHeader *titleHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderID];
    return titleHeader;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isMemberOfClass:[ChartSectionHeader class]]) {
        ((UITableViewHeaderFooterView *)view).contentView.backgroundColor = kChartHeaderBgColor;
    }
}

#pragma mark - UIScorllView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}


@end
