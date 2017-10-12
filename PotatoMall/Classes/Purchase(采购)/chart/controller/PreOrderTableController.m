//
//  PreOrderTableController.m
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "PreOrderTableController.h"
#import "CarryCell.h"
#import "OrderAddressCell.h"
#import "OrderTypeCell.h"
#import "ChartCell.h"
#import "OrderPayFooter.h"
#import "OrderFeedCell.h"
#import "PayTypeCell.h"
#import "HTSubmitBar.h"
#import "NSDictionary+Extension.h"
#import "TransportTableController.h"
#import "AddMofityAdrTableController.h"

static NSString *ChartCellID = @"ChartCellID";
static NSString *CarryCellID = @"CarryCellID";
static NSString *PayTypeCellID = @"PayTypeCellID";
static NSString *OrderTypeCellID = @"OrderTypeCellID";
static NSString *OrderAddressCellID = @"OrderAddressCellID";
static NSString *OrderFeedCellID = @"OrderFeedCellID";
static NSString *OrderPayFooterID = @"OrderPayFooterID";

#define kCarraySectionIdx           0
#define kPayTypeSectionIdx          1
#define kOrderTypeSectionIdx        2
#define kAddressSectionIdx          3
#define kOrdersSectionIdx           4
#define kRemarkSectionIdx           5


@interface PreOrderTableController ()
@property (nonatomic,weak)HTSubmitBar *toolBar;
@property (weak, nonatomic)  UILabel *carryLabel;
@property (weak, nonatomic)  UILabel *payTypeLabel;
@property (weak, nonatomic)  UILabel *orderTypeLabel;
@property (weak, nonatomic)  OrderFeedCell *orderCell;
@property(nonatomic,strong) NSDictionary *defaultAdr;

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
    [self.navigationController  setToolbarHidden:NO animated:NO];
    [self reqDefaultReciveAdr];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"transportSegue"]) {
        TransportTableController *destinationControl = (TransportTableController*)[segue destinationViewController];
        destinationControl.carryLabel = self.carryLabel;
    }else if ([segue.identifier isEqualToString:@"addModifySegue"]) {
        AddMofityAdrTableController *destinationControl = [segue destinationViewController];
        if (self.defaultAdr == nil) {
            destinationControl.editType = ReviceAdrTypeAdd;
        }else{
            destinationControl.editType = ReviceAdrTypeModify;
            destinationControl.adrInfo = self.defaultAdr;
        }
    }
}

#pragma mark - setup UI 
- (void)setupNavToolbar
{
    __block typeof(self) blockSelf = self;
    HTSubmitBar *bar = [HTSubmitBar customBarWithAllBlock:^{
        NSLog(@"submit order...");
        NSMutableDictionary *params = [blockSelf paramsCurrent];
        [blockSelf prepareforSubmitOrderWithParams:params];
        
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
    
    UINib *PayTypeCellNib = [UINib nibWithNibName:@"PayTypeCell" bundle:nil];
    [self.tableView registerNib:PayTypeCellNib forCellReuseIdentifier:PayTypeCellID];
    
    UINib *OrderTypeCellNib = [UINib nibWithNibName:@"OrderTypeCell" bundle:nil];
    [self.tableView registerNib:OrderTypeCellNib forCellReuseIdentifier:OrderTypeCellID];
    
    UINib *OrderAddressCellNib = [UINib nibWithNibName:@"OrderAddressCell" bundle:nil];
    [self.tableView registerNib:OrderAddressCellNib forCellReuseIdentifier:OrderAddressCellID];
    
    UINib *feedNib = [UINib nibWithNibName:@"OrderFeedCell" bundle:nil];
    [self.tableView registerNib:feedNib forCellReuseIdentifier:OrderFeedCellID];
    
    UINib *footerNib = [UINib nibWithNibName:@"OrderPayFooter" bundle:nil];
    [self.tableView registerNib:footerNib forHeaderFooterViewReuseIdentifier:OrderPayFooterID];
}

#pragma mark - private methods
- (NSMutableDictionary*)paramsCurrent
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([self.buyType isEqualToString:kByNow]) {
        GoodsModel *obj = [self.goodsArray firstObject];
        params[kGoodsInfoIdKey] = obj.goodsInfoId;
        params[kNumKey] = obj.selectedCount;
    }else{
        NSMutableArray *goodsArr = [NSMutableArray array];
        for (GoodsModel *obj in self.goodsArray) {
            NSMutableDictionary *goods = [NSMutableDictionary dictionary];
            goods[kGoodsInfoIdKey] = obj.goodsInfoId;
            goods[kNumKey] = obj.selectedCount;
            [goodsArr addObject:goods];
        }
        params[kGoodsInfosKey] = goodsArr;
    }
    NSString *phone = [UserModelUtil sharedInstance].userModel.phone;
    params[kShippingMobileKey] = phone ;
    params[kShippingPersonKey] = phone;
    params[kDeliveryTypKey] = @"1";
    params[@"orderLinePay"] = @"0";
    
    
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

- (NSDictionary *)whetherUserUnionParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    return params;
}

//请求默认收货地址。
- (void)reqDefaultReciveAdr
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    NSString *subUrl = @"address/selectUserDefaultAddress";
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
    [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
        if (status == StatusTypSuccess) {
            id obj = [DataUtil dictionaryWithJsonStr:data];
            HTLog(@"address default = %@",obj);
            self.defaultAdr = [obj objectForKey:@"obj"];
        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
        [self.tableView reloadData];
    } reqFail:^(int type, NSString *msg) {
        [self.tableView reloadData];
//        [SVProgressHUD showErrorWithStatus:msg];
    }];
}
//提交订单之前请求是否加入合作社。
- (void)prepareforSubmitOrderWithParams:(NSMutableDictionary*)params
{
    NSDictionary *unionParams =[self whetherUserUnionParams];
    [self whetherUserUnion:unionParams resultBlock:^(NSString *uionId, BOOL reqState) {
        if (reqState == YES) {
            if ((uionId == nil) || (uionId.length <= 0)){
                params[@"type"] = @"2";
                params[@"unionId"] = @"";
            }else{
                params[@"unionId"] = uionId;
                params[@"type"] = @"1";
            }
            [self submitOrdderDataWithParams:params];
        }else{
            HTLog(@"request timeout");
        }
    }];
}

#pragma mark - requset server
- (void)submitOrdderDataWithParams:(NSMutableDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }else{
        NSString *subUrl = nil;
        if ([self.buyType isEqualToString:kByNow]) {
            subUrl = @"order/buyNowCommitOrder";
        }else{
            subUrl = @"order/commitOrder";
        }
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [self.tableView.mj_footer endRefreshing];
            if (status == StatusTypSuccess) {
                HTLog(@"success order submit ");
                NSArray *goodsArr = params[kGoodsInfosKey];
                NSInteger count = [UserModelUtil sharedInstance].chartCount;
                count = count - goodsArr.count;
                if(count <= 0){
                    count = 0;
                }
                [UserModelUtil sharedInstance].chartCount = count;
                [self performSegueWithIdentifier:@"submitSuccSugue" sender:nil];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [self.tableView.mj_footer endRefreshing];
        }];
    }
}

//检查用户是否加入联合社
- (void)whetherUserUnion:(NSDictionary*)params resultBlock:(void(^)(NSString *uionId,BOOL reqState))resultBlock
{
    if ([RequestUtil networkAvaliable] == NO) {
        return;
    }else{
        NSString *subUrl = @"/user_union/whetherUserUnion";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            NSString *unionID = nil;
            if (status == StatusTypSuccess) {
                NSDictionary *dataDict = [DataUtil dictionaryWithJsonStr:data];
                NSDictionary *obj = dataDict[@"obj"];
                unionID = [obj strValueForKey:@"unionId"];
            }
            resultBlock(unionID,YES);
        } reqFail:^(int type, NSString *msg) {
            resultBlock(nil,NO);
        }];
    }
}

#pragma mark - UITableView ---  Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if(section == kOrdersSectionIdx){
        return [self.goodsArray count];
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kCarraySectionIdx) {
        CarryCell *cell = [tableView dequeueReusableCellWithIdentifier:CarryCellID];
        self.carryLabel = cell.carryLabel;
        return cell;
    }else if(indexPath.section == kPayTypeSectionIdx){
        PayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:PayTypeCellID];
        self.payTypeLabel = cell.payTypeLabel;
        return cell;
    }else if(indexPath.section == kOrderTypeSectionIdx){
        OrderTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderTypeCellID];
        self.orderTypeLabel = cell.orderTypeLabel;
        return cell;
    }else if(indexPath.section == kAddressSectionIdx){
        OrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderAddressCellID];
        cell.adrInfo = self.defaultAdr;
        return cell;
    }else if(indexPath.section == kOrdersSectionIdx){
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
//    if (section == 0) {
        return 0.001;
//    }else if(section == 1){
//        return 0.001;
//    }else{
//        return 16;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == 0) {
        return 10;
//    }else if(section == 1){
//        return 50;
//    }else{
//        return 0.001;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == kCarraySectionIdx) {
        [self performSegueWithIdentifier:@"transportSegue" sender:nil];
    }else if (indexPath.section == kAddressSectionIdx) {
        [self performSegueWithIdentifier:@"addModifySegue" sender:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kRemarkSectionIdx) {
        return 150;
    }else if(indexPath.section == kAddressSectionIdx){
        return 80;
    }else if(indexPath.section == kOrdersSectionIdx){
        return 120;
    }else{
        return 50;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return nil;
//    }else if(section == 1){
//        OrderPayFooter *payFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderPayFooterID];
//        return payFooter;
//    }else{
//        return nil;
//    }
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//{
//    if ([view isMemberOfClass:[OrderPayFooter class]]) {
//        OrderPayFooter *footer =  (OrderPayFooter *)view;
//        [footer.backgroundView setBackgroundColor:[UIColor whiteColor]];
//    }
//}

#pragma mark - UIScorllView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}


@end
