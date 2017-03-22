//
//  OrderDetailTableController.m
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderDetailTableController.h"
#import "OrderCell.h"
#import "OrderModel.h"
#import "HTCalculatorToolBar.h"
#import "OrderStateHeader.h"
//#import "OrderDetailStateFooter.h"
#import "OrderDetailTransHeader.h"
#import "TopScrollView.h"
#import "CancelOrderCell.h"
#import "OrderDetailFooter.h"


static NSString *OrderCellID = @"OrderCell";

static NSString *CancelOrderCellID = @"CancelOrderCell";

static NSString *OrderStateHeaderID = @"OrderStateHeaderID";

static NSString *OrderDetailTransHeaderID = @"OrderDetailTransHeaderID";
static NSString *OrderDetailFooterID = @"OrderDetailFooterID";



@interface OrderDetailTableController ()
//@property (nonatomic,strong)NSMutableArray *ordersArray;
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
    UINib *cellNib = [UINib nibWithNibName:@"OrderCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:OrderCellID];
    
    UINib *cancelCellNib = [UINib nibWithNibName:@"CancelOrderCell" bundle:nil];
    [self.tableView registerNib:cancelCellNib forCellReuseIdentifier:CancelOrderCellID];
    
    UINib *headerNib = [UINib nibWithNibName:@"OrderStateHeader" bundle:nil];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:OrderStateHeaderID];
    
    //footer register nib
    UINib *transheaderNib = [UINib nibWithNibName:@"OrderDetailTransHeader" bundle:nil];
    [self.tableView registerNib:transheaderNib forHeaderFooterViewReuseIdentifier:OrderDetailTransHeaderID];
    
    //footer register nib
    UINib *counterNib = [UINib nibWithNibName:@"OrderDetailFooter" bundle:nil];
    [self.tableView registerNib:counterNib forHeaderFooterViewReuseIdentifier:OrderDetailFooterID];
}


#pragma mark - requset server
- (void)cancelCurrentOrder
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }else{
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.orderModel.orderId,kOrderIdKey, nil];
        NSString *subUrl = @"order/cancelOrder";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
//            [SVProgressHUD showInfoWithStatus:msg];
            if (status == StatusTypSuccess) {
                HTLog(@"add to chart success baby .....");
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:kCancelOrderSuccessNotification object:self.orderModel];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

#pragma mark - UITableView --- Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.orderModel.list count];
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0)) {
        OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCellID];
        OrderGoodsModel *goodsModel = self.orderModel.list[indexPath.row];
        [cell updateUIWithModel:goodsModel totalCount:self.orderModel.list.count row:indexPath.row];
//        cell.model = goodsModel;
        return cell;
    }else{
        CancelOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CancelOrderCellID];
        cell.model = self.orderModel;
        __block typeof(self) blockSelf = self;
        cell.cancelBlock = ^(){
            HTLog(@"tap cancel button ");
            [blockSelf cancelCurrentOrder];
        };
        
        return cell;
    }
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 56;
    }else{
        return 158;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }else{
        return 50;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section == 0) {
//        OrderDetailFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderDetailFooterID];
//        [footer setOrderModel:self.orderModel];
//        return footer;
//    }else{
//        return nil;
//    }
//}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        OrderStateHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderStateHeaderID];
        //    OrderModel *orderModel = self.ordersArray[section];
        [header setOrderModel:self.orderModel];
        return header;
    }else if(section == 1){
        OrderDetailTransHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderDetailTransHeaderID];
        header.orderModel = self.orderModel;
        return header;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isMemberOfClass:[OrderStateHeader class]]) {
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isMemberOfClass:[OrderDetailTransHeader class]]) {
        OrderDetailTransHeader *footer =  (OrderDetailTransHeader *)view;
        footer.contentView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - UIScorllView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}


@end
