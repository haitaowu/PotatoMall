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


@interface PreOrderTableController ()<UIActionSheetDelegate>
@property (nonatomic,weak)HTSubmitBar *toolBar;
@property (weak, nonatomic)  UILabel *carryLabel;
@property (weak, nonatomic)  UILabel *payTypeLabel;
@property (weak, nonatomic)  UILabel *orderTypeLabel;
@property (weak, nonatomic)  OrderFeedCell *orderCell;
@property(nonatomic,strong) NSDictionary *defaultAdr;
@property(nonatomic,copy) NSString *orderLinePay;
//订单类型 个人是2 联全社是1
@property(nonatomic,copy) NSString *unionId;

@end

@implementation PreOrderTableController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderLinePay = @"0";
    [self setupNavToolbar];
    [self setupTableView];
    [self productsTotalPrice];
    //是否加入联全社
    [self checkUserUnionState];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController  setToolbarHidden:NO animated:NO];
    [self reqDefaultReciveAdr];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
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
    }else if ([segue.identifier isEqualToString:@"submitSuccSugue"]) {
        [self.navigationController  setToolbarHidden:YES animated:NO];
    }
}

#pragma mark - setup UI 
- (void)setupNavToolbar
{
    __block typeof(self) blockSelf = self;
//    HTSubmitBar *bar = [HTSubmitBar customBarWithAllBlock:^{
//        NSLog(@"submit order...");
////        [blockSelf prepareforSubmitOrderWithParams:params];
//        [blockSelf checkInputPrepareForSubmit];
//    }];
    
    HTSubmitBar *bar = [HTSubmitBar submitBarWithAllBlock:^{
        [blockSelf checkInputPrepareForSubmit];
    }];
    CGRect barF = CGRectMake(0, 0, kScreenWidth, 44);
    bar.frame = barF;
    self.toolBar = bar;
//    CGRect frame = self.navigationController.toolbar.frame;
//    bar.frame = frame;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:bar];
    NSArray *barItems = [NSArray array];
    if (@available(iOS 11,*)){
        barItems = @[barItem];
    }else{
        UIBarButtonItem *flexLeftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *flexibleButtonItemRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        barItems = @[flexLeftItem,barItem,flexibleButtonItemRight];
    }
    self.toolbarItems = barItems;
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
    params[@"orderLinePay"] = self.orderLinePay;
    if (self.unionId == nil) {
        params[@"type"] = @"2";
    }else{
        params[@"unionId"] = self.unionId;
        params[@"type"] = @"1";
    }
    params[@"shoppingAddrId"] = [self.defaultAdr strValueForKey:@"addressId"];
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




// union type personal type = 2 union type = 1
- (void)shouldShowOrderTypeSheetView
{
    if (self.unionId == nil) {
        [SVProgressHUD showInfoWithStatus:@"个人订单不可选择"];
        return;
    }
    NSString *title = @"选择订单类型";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"个人订单",@"联合社订单",nil];
    actionSheet.tag = 22;
    [actionSheet showInView:self.view];
}

//pay type  1:pay online  0: pay after recived
- (void)showPayTypeSheetView
{
    NSString *title = @"选择支付方式";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"货到付款",@"在线支付",nil];
    actionSheet.tag = 11;
    [actionSheet showInView:self.view];
}

//检查是否加入联全社
- (void)checkUserUnionState
{
    NSDictionary *unionParams =[self whetherUserUnionParams];
    [self whetherUserUnion:unionParams resultBlock:^(NSString *uionId, BOOL reqState) {
        if (reqState == YES) {
            if ((uionId == nil) || (uionId.length <= 0)){
                self.unionId = nil;
            }else{
                self.unionId = uionId;
            }
        }else{
            self.unionId = nil;
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
            [SVProgressHUD dismiss];
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

- (void)checkInputPrepareForSubmit
{
    if (self.defaultAdr == nil) {
        [SVProgressHUD showInfoWithStatus:@"请选择收货地址"];
        return;
    }
    [SVProgressHUD showWithStatus:@"购买中..."];
    NSMutableDictionary *params = [self paramsCurrent];
    [self submitOrdderDataWithParams:params];
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
            self.defaultAdr = nil;
        }
        [self.tableView reloadData];
    } reqFail:^(int type, NSString *msg) {
        self.defaultAdr = nil;
        [self.tableView reloadData];
        //        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - UIAction sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    HTLog(@"button index = %ld",buttonIndex);
    if (actionSheet.tag == 11) {
        switch (buttonIndex) {
            case 0:
                self.orderLinePay = @"0";
                self.payTypeLabel.text = @"货到付款";
                break;
            case 1:
                self.orderLinePay = @"1";
                self.payTypeLabel.text = @"在线支付";
                break;
            default:
                break;
        }
    }else if (actionSheet.tag == 22) {
        switch (buttonIndex) {
            case 0:
                self.orderLinePay = @"2";
                self.payTypeLabel.text = @"个人订单";
                break;
            case 1:
                self.orderLinePay = @"1";
                self.payTypeLabel.text = @"联合社订单";
                break;
            default:
                break;
        }
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
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == kCarraySectionIdx) {
        [self performSegueWithIdentifier:@"transportSegue" sender:nil];
    }else if (indexPath.section == kPayTypeSectionIdx) {
        [self showPayTypeSheetView];
    }else if (indexPath.section == kOrderTypeSectionIdx) {
        [self shouldShowOrderTypeSheetView];
    }else if (indexPath.section == kAddressSectionIdx) {
        if (self.defaultAdr != nil) {
            [self performSegueWithIdentifier:@"adrListSegue" sender:nil];
        }else{
            [self performSegueWithIdentifier:@"addModifySegue" sender:nil];
        }
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


#pragma mark - UIScorllView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}


@end
