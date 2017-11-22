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
#import "ChartTableController.h"
#import "OrderDetailTransHeader.h"
#import "TopScrollView.h"
#import "CancelOrderCell.h"
#import "OrderDetailFooter.h"


static NSString *OrderCellID = @"OrderCell";

static NSString *CancelOrderCellID = @"CancelOrderCell";

static NSString *OrderStateHeaderID = @"OrderStateHeaderID";

static NSString *OrderDetailTransHeaderID = @"OrderDetailTransHeaderID";
static NSString *OrderDetailFooterID = @"OrderDetailFooterID";



@interface OrderDetailTableController ()<UIAlertViewDelegate>
//@property (nonatomic,strong)NSMutableArray *ordersArray;
//@property (strong, nonatomic)  TopScrollView *tableviewHeaderView;
@property (nonatomic,strong)NSArray *subItemTitles;
@end

@implementation OrderDetailTableController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    if ((self.orderModel == nil) &&(self.changeCode != nil)) {
       NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.changeCode,kOrderIdKey, nil];
        [self reqOrderDetailWithParams:params];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController  setToolbarHidden:YES animated:NO];
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

- (void)cancelCurrentOrder
{
    NSString *message = @"确定取消订单吗？";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag = 88;
}

- (void)showPrepareAlertView
{
    NSString *message = @"线上支付暂时还没有开通，请联系平台客服咨询订单的支付方式。";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag = 88;
}

- (void)showDeleteOrderAlertView
{
    NSString *message = @"确定删除订单吗？";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag = 99;
}

- (void)showGoodsToChartViewWithModel:(OrderModel*) model
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Purchase" bundle:nil];
    ChartTableController *detailControl = [storyBoard instantiateViewControllerWithIdentifier:@"ChartTableController"];
    detailControl.goodsArray = [NSMutableArray arrayWithArray: model.list];
    [self.navigationController pushViewController:detailControl animated:YES];
}


- (void)returnOrderAlertView
{
    NSString *message = @"如需退单请联系平台客服人员，并告知退单原因。";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag = 22;
}


- (void)confirmRecivedAlertView
{
    NSString *message = @"请确认您已成功提取所有订单上的商品，点击【确认】后该订单将被视为交易完成";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag = 33;
}

//修改订单状态。
- (void)updateOrderStatusWithStatus:(NSString*)status
{
    //14:退单 3:确定提货
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kOrderIdKey] = self.orderModel.orderId;
    NSString *name = [UserModelUtil sharedInstance].userModel.realName;
    if (name.length <= 0) {
        name = [UserModelUtil sharedInstance].userModel.phone;
    }
    params[kUserNameKey] = name;
    params[@"status"] = status;
    [self submitUpdateStatusWithParams:params];
}


//添加到购物车的请求参数
- (NSDictionary*)chartParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = [UserModelUtil sharedInstance].userModel.userId;
    NSMutableArray *carts = [NSMutableArray array];
    for (GoodsModel *obj in self.orderModel.list) {
        NSMutableDictionary *goods = [NSMutableDictionary dictionary];
        goods[kGoodsInfoIdKey] = obj.goodsId;
        goods[kNumKey] = obj.num;
        [carts addObject:goods];
    }
    params[@"carts"] = carts;
    return params;
}

#pragma mark - requset server
- (void)submitUpdateStatusWithParams:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }else{
        NSString *subUrl = @"order/updateStatusOrder";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
        }];
    }
}
- (void)addGoodsToChartWithOrderModel:(OrderModel*)orderModel
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }else{
        NSDictionary *params = [self chartParams];
        NSString *subUrl = @"cart/addShopCart";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [self showGoodsToChartViewWithModel:orderModel];
            }else{
                [SVProgressHUD showErrorWithStatus:@"商品已经下架"];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            //            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

- (void)submitCancelCurrentOrder{
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

- (void)submitDeleteCurrentOrder{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }else{
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.orderModel.orderId,kOrderIdKey, nil];
        NSString *subUrl = @"order/deleteOrder";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            //            [SVProgressHUD showInfoWithStatus:msg];
            if (status == StatusTypSuccess) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            //            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

- (void)reqOrderDetailWithParams:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        NSString *subUrl = @"order/detail";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                self.orderModel =  [OrderModel orderModelWithData:data];
                [self.tableView reloadData];
            }
        } reqFail:^(int type, NSString *msg) {
            
        }];
    }
}


#pragma mark - UIAlertViewDelegate delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 88) {
        if (buttonIndex == 1) {
            [self submitCancelCurrentOrder];
        }
    }else if (alertView.tag == 99) {
        if (buttonIndex == 1) {
            [self submitDeleteCurrentOrder];
        }
    }else if (alertView.tag == 22) {
        //14:退单 3:确定提货
        if (buttonIndex == 1) {
            [self updateOrderStatusWithStatus:@"14"];
        }
    }else if (alertView.tag == 33) {
        if (buttonIndex == 1) {
            [self updateOrderStatusWithStatus:@"3"];
        }
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
        if (self.changeCode == nil) {
            return 1;
        }else{
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0)) {
        OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCellID];
        GoodsModel *goodsModel = self.orderModel.list[indexPath.row];
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
        
        //支付订单
        cell.payOrderBlock = ^(){
            [blockSelf showPrepareAlertView];
        };
        
        //删除订单
        cell.deleteOrderBlock = ^(OrderModel *model){
            [blockSelf showDeleteOrderAlertView];
        };
        
        //重新、再次购买
        cell.reBuyBlock = ^(OrderModel *model){
            [blockSelf addGoodsToChartWithOrderModel:model];
        };
        
        //14:退单 3:确定提货
        //确定提货
        cell.confirmRecivedBlock = ^(){
            [self confirmRecivedAlertView];
        };
        
        //退单
        cell.retuOrderBlock = ^(){
            [self returnOrderAlertView];
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
