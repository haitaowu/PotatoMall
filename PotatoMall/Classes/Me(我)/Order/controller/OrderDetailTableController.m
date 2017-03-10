//
//  OrderDetailTableController.m
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderDetailTableController.h"
#import "OrderDetailCell.h"
#import "OrderModel.h"
#import "HTCalculatorToolBar.h"
#import "OrderStateHeader.h"
#import "OrderDetailStateFooter.h"
#import "TopScrollView.h"


static NSString *OrderDetailCellID = @"OrderDetailCell";

static NSString *OrderStateHeaderID = @"OrderStateHeaderID";

static NSString *OrderDetailStateFooterID = @"OrderDetailStateFooterID";

@interface OrderDetailTableController ()
@property (nonatomic,strong)NSMutableArray *ordersArray;
@property (strong, nonatomic) TopScrollView *tableviewHeaderView;
@property (nonatomic,strong)NSArray *subItemTitles;
@end

@implementation OrderDetailTableController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

#pragma mark - setup UI 
- (void)setupTableView
{
    UINib *cellNib = [UINib nibWithNibName:@"OrderDetailCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:OrderDetailCellID];
    
    UINib *headerNib = [UINib nibWithNibName:@"OrderStateHeader" bundle:nil];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:OrderStateHeaderID];
    
    //footer register nib
    UINib *footerNib = [UINib nibWithNibName:@"OrderDetailStateFooter" bundle:nil];
    [self.tableView registerNib:footerNib forHeaderFooterViewReuseIdentifier:OrderDetailStateFooterID];
}


#pragma mark - UITableView --- Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return [self.ordersArray count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OrderModel *orderModel = self.ordersArray[section];
    NSArray *goods = orderModel.list;
//    return [goods count];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderDetailCellID];
    return cell;
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderModel *orderModel = self.ordersArray[section];
    OrderDetailStateFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderDetailStateFooterID];
    return footer;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderStateHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderStateHeaderID];
//    OrderModel *orderModel = self.ordersArray[section];
    [header setOrderModel:self.orderModel];
    return header;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isMemberOfClass:[OrderStateHeader class]]) {
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isMemberOfClass:[OrderDetailStateFooter class]]) {
        OrderDetailStateFooter *footer =  (OrderDetailStateFooter *)view;
        footer.contentView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - UIScorllView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}


@end
