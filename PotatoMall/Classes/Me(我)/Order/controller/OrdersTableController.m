//
//  OrdersTableController.m
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrdersTableController.h"
#import "OrderCell.h"
#import "OrderModel.h"
#import "HTCalculatorToolBar.h"
#import "OrderStateHeader.h"
#import "OrderStateFooter.h"
#import "TopScrollView.h"
#import "OrderDetailTableController.h"
#import "OrderGoodsModel.h"



static NSString *OrderCellID = @"OrderCell";

static NSString *OrderStateHeaderID = @"OrderStateHeaderID";

static NSString *OrderStateFooterID = @"OrderStateFooterID";

@interface OrdersTableController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong)NSMutableArray *ordersArray;
@property (nonatomic,strong)NSMutableArray *originOrders;
@property (strong, nonatomic) TopScrollView *tableviewHeaderView;
@property (nonatomic,strong)NSArray *subItemTitles;
@property (nonatomic,assign) BOOL firstReqFinished;
@end

@implementation OrdersTableController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self reqOrdersData];
    [self setupTableviewTableheader];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelOrderSuccess:) name:kCancelOrderSuccessNotification object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        OrderDetailTableController *destinationControl = (OrderDetailTableController*)[segue destinationViewController];
        destinationControl.orderModel = sender;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - private methods
- (void)updateUIWithSelectedStatus:(int)status
{
    //订单状态 0待确认 1未付款 2待提货 3已完成  -1为全部（暂定）
    if (status == -1) {
       self.ordersArray = self.originOrders;
    }else{
        NSMutableArray *orders = [self ordersWithStatus:[NSString stringWithFormat:@"%d",status]];
        self.ordersArray = orders;
    }
    [self.tableView reloadData];
}

- (NSMutableArray*)ordersWithStatus:(NSString*)status
{
    NSMutableArray *orders = [NSMutableArray array];
    for (OrderModel *obj in self.originOrders) {
        if ([obj.orderStatus isEqualToString:status]) {
            [orders addObject:obj];
        }
    }
    return orders;
}

#pragma mark - setup UI
- (void)setupTableviewTableheader
{
    //订单状态 0待确认 1未付款 2待提货 3已完成  -1为全部（暂定）
    self.subItemTitles = @[@"全部",@"待确认",@"未付款",@"待提货",@"已完成"];
    CGRect frame =  CGRectMake(0, 0, kScreenWidth, 44);
    self.tableviewHeaderView = [[TopScrollView alloc] initWithFrame:frame];
    self.tableviewHeaderView.backgroundColor = [UIColor whiteColor];
    self.tableviewHeaderView.titles = [NSMutableArray arrayWithArray:_subItemTitles];
    self.tableviewHeaderView.normalTextColor = kMainTitleBlackColor;
    self.tableviewHeaderView.selectedTextColor = kMainNavigationBarColor;
    self.tableviewHeaderView.sliderColor = kMainNavigationBarColor;
    self.tableviewHeaderView.sliderWidthPercent = 0.8;
    [self.tableviewHeaderView scrollVisibleTo:0];
    __block typeof(self) blockSelf = self;
    self.tableviewHeaderView.selectedItemTitleBlock = ^(NSInteger idx ,NSString *title){
        HTLog(@"top at scrollview at index title %@",title);
        int index = (int)idx - 1;
        [blockSelf updateUIWithSelectedStatus:index];
    };
    self.tableView.tableHeaderView = self.tableviewHeaderView;
}
- (void)setupTableView
{
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"OrderCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:OrderCellID];
    
    UINib *headerNib = [UINib nibWithNibName:@"OrderStateHeader" bundle:nil];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:OrderStateHeaderID];
    
    //footer register nib
    UINib *footerNib = [UINib nibWithNibName:@"OrderStateFooter" bundle:nil];
    [self.tableView registerNib:footerNib forHeaderFooterViewReuseIdentifier:OrderStateFooterID];
}

#pragma mark - selectors
- (void)cancelOrderSuccess:(NSNotification*)sender
{
    OrderModel *model = sender.object;
    [self.ordersArray removeObject:model];
    [self.tableView reloadData];
}

#pragma mark - requset server
- (void)reqOrdersData
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        id userId = [UserModelUtil sharedInstance].userModel.userId;
        params[kUserIdKey] = userId;
        NSString *subUrl = @"order/list";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
//            [SVProgressHUD showInfoWithStatus:msg];
            self.firstReqFinished = YES;
            if (status == StatusTypSuccess) {
                self.originOrders = [OrderModel ordersWithData:data];
                self.ordersArray =  self.originOrders;
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            self.firstReqFinished = YES;
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

#pragma mark - UITableView --- Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.ordersArray count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OrderModel *orderModel = self.ordersArray[section];
    NSArray *goods = orderModel.list;
    return [goods count];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCellID];
    OrderModel *orderModel = self.ordersArray[indexPath.section];
    OrderGoodsModel *goodsModel = orderModel.list[indexPath.row];
    [cell updateUIWithModel:goodsModel totalCount:orderModel.list.count row:indexPath.row];
    return cell;
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderModel *orderModel = self.ordersArray[section];
    OrderStateFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderStateFooterID];
    [footer setOrderModel:orderModel];
    return footer;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderStateHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderStateHeaderID];
    OrderModel *orderModel = self.ordersArray[section];
    [header setOrderModel:orderModel];
    return header;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isMemberOfClass:[OrderStateHeader class]]) {
//        ((OrderStateHeader *)view).contentView.backgroundColor = kChartHeaderBgColor;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isMemberOfClass:[OrderStateFooter class]]) {
        OrderStateFooter *footer =  (OrderStateFooter *)view;
        footer.contentView.backgroundColor = [UIColor whiteColor];
        OrderModel *orderModel = self.ordersArray[section];
        __block typeof(self) blockSelf = self;
        footer.detailBlock = ^(){
            [blockSelf performSegueWithIdentifier:@"detailSegue" sender:orderModel];
        };
    }
}

#pragma mark - UIScorllView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}

#pragma mark - DZNEmptyDataSetSource Methods
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -144;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if ([RequestUtil networkAvaliable] == NO) {
        NSString *text = @"咦！断网了";
        NSDictionary *attributes = @{NSFontAttributeName: kEmptyDataTitleFont,
                                     NSForegroundColorAttributeName: UIColorFromRGB(0x888888)};
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }else if ((self.firstReqFinished == YES) && (self.ordersArray.count <= 0)){
        NSString *text = @"没有找到该状态的相关订单";
        NSDictionary *attributes = @{NSFontAttributeName: kEmptyDataTitleFont,
                                     NSForegroundColorAttributeName: UIColorFromRGB(0x888888)};
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }else{
        return [[NSAttributedString alloc] init];
    }
}

@end
