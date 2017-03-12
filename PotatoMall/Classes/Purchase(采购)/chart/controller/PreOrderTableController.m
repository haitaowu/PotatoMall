//
//  PreOrderTableController.m
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "PreOrderTableController.h"
#import "CarryCell.h"
#import "ChartCell.h"
#import "OrderPayFooter.h"
#import "OrderFeedCell.h"
#import "HTSubmitBar.h"
#import "TransportTableController.h"

static NSString *ChartCellID = @"ChartCellID";
static NSString *CarryCellID = @"CarryCellID";
static NSString *OrderFeedCellID = @"OrderFeedCellID";
static NSString *OrderPayFooterID = @"OrderPayFooterID";


@interface PreOrderTableController ()
@property (nonatomic,weak)HTSubmitBar *toolBar;
@property (weak, nonatomic)  UILabel *carryLabel;
@property (weak, nonatomic)  OrderFeedCell *orderCell;

@end

@implementation PreOrderTableController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavToolbar];
    [self setupTableView];
    [self productsTotalPrice];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"transportSegue"]) {
        TransportTableController *destinationControl = (TransportTableController*)[segue destinationViewController];
        destinationControl.carryLabel = self.carryLabel;
    }
}

#pragma mark - setup UI 
- (void)setupNavToolbar
{
    __block typeof(self) blockSelf = self;
    HTSubmitBar *bar = [HTSubmitBar customBarWithAllBlock:^{
        NSLog(@"submit order...");
        NSDictionary *params = [blockSelf paramsCurrent];
        [blockSelf submitOrdderDataWithParams:params];
        
    }];
    self.toolBar = bar;
    CGRect frame = self.navigationController.toolbar.frame;
    bar.frame = frame;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:bar];
    self.toolbarItems = @[barItem];
}

- (void)setupTableView
{
    UINib *cellNib = [UINib nibWithNibName:@"ChartCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:ChartCellID];
    
    UINib *carryCellNib = [UINib nibWithNibName:@"CarryCell" bundle:nil];
    [self.tableView registerNib:carryCellNib forCellReuseIdentifier:CarryCellID];
    
    
    UINib *feedNib = [UINib nibWithNibName:@"OrderFeedCell" bundle:nil];
    [self.tableView registerNib:feedNib forCellReuseIdentifier:OrderFeedCellID];
    
    UINib *footerNib = [UINib nibWithNibName:@"OrderPayFooter" bundle:nil];
    [self.tableView registerNib:footerNib forHeaderFooterViewReuseIdentifier:OrderPayFooterID];
}

#pragma mark - private methods
- (NSDictionary*)paramsCurrent
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *goodsArr = [NSMutableArray array];
    for (GoodsModel *obj in self.goodsArray) {
        NSMutableDictionary *goods = [NSMutableDictionary dictionary];
        goods[kGoodsInfoIdKey] = obj.goodsInfoId;
        goods[kNumKey] = obj.selectedCount;
        [goodsArr addObject:goods];
    }
    params[kGoodsInfosKey] = goodsArr;
    params[kShippingMobileKey] = @"18061955875";
    params[kShippingPersonKey] = @"18061955875";
    params[kDeliveryTypKey] = @"1";
    
    params[kUserIdKey] = [UserModelUtil sharedInstance].userModel.userId;
    NSString *feedStr = self.orderCell.textView.text;
    if (feedStr.length > 0) {
        params[kRemarkKey] = feedStr;
    }
    return params;
}

- (NSString*)productsTotalPrice
{
    CGFloat totalPrice = 0;
    for (GoodsModel *obj in self.goodsArray) {
        totalPrice += [self calculatorPriceWithModel:obj];
    }
    NSString *priceStr = [NSString stringWithFormat:@"%.2f",totalPrice];
    [self.toolBar updateTotalPriceTitle:priceStr];
    return priceStr;
}

- (CGFloat)calculatorPriceWithModel:(GoodsModel*)model
{
    NSInteger count = [model.selectedCount integerValue];
    CGFloat price = [model.price floatValue];
    CGFloat totalPrice = price * count;
    return totalPrice;
}

#pragma mark - requset server
- (void)submitOrdderDataWithParams:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }else{
        NSString *subUrl = @"order/commitOrder";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [self.tableView.mj_footer endRefreshing];
            if (status == StatusTypSuccess) {
                HTLog(@"success order submit ");
                [self performSegueWithIdentifier:@"submitSuccSugue" sender:nil];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [self.tableView.mj_footer endRefreshing];
        }];
    }
}

#pragma mark - UITableView ---  Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return [self.goodsArray count];
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CarryCell *cell = [tableView dequeueReusableCellWithIdentifier:CarryCellID];
        self.carryLabel = cell.carryLabel;
        return cell;
    }else if(indexPath.section == 1){
        ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:ChartCellID];
        GoodsModel *model = self.goodsArray[indexPath.row];
        [cell updateNODeleteWithModel:model];
        __block typeof(self) blockSelf = self;
        cell.countBlock = ^(GoodsModel *model){
            NSInteger count = [model.selectedCount integerValue];
            CGFloat price = [model.price floatValue];
            CGFloat totalPrice = price * count;
            HTLog(@"current count = %f",totalPrice);
            [blockSelf productsTotalPrice];
        };
        return cell;
    }else{
        OrderFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderFeedCellID];
        self.orderCell = cell;
        return cell;
    }
}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }else if(section == 1){
        return 0.001;
    }else{
        return 16;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 16;
    }else if(section == 1){
        return 50;
    }else{
        return 0.001;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"transportSegue" sender:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }else if(indexPath.section == 1){
        return 120;
    }else{
        return 150;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else if(section == 1){
        OrderPayFooter *payFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderPayFooterID];
        return payFooter;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isMemberOfClass:[OrderPayFooter class]]) {
        OrderPayFooter *footer =  (OrderPayFooter *)view;
        [footer.backgroundView setBackgroundColor:[UIColor whiteColor]];
    }
}

#pragma mark - UIScorllView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}


@end
