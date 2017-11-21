//
//  plantlistViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "plantlistViewController.h"
#import "OrderModel.h"
#import "OrderCell.h"
#import "GoodsModel.h"
#import "OrderStateHeader.h"
#import "OrderStateFooter.h"
#import "OrderDetailTableController.h"

static NSString *OrderCellID = @"OrderCell";
static NSString *OrderStateHeaderID = @"OrderStateHeaderID";
static NSString *OrderStateFooterID = @"OrderStateFooterID";

@interface plantlistViewController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong)NSMutableArray *ordersArray;

@end

@implementation plantlistViewController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCateGoryView];
    self.title=@"合作社订单";

    self.mtableview.emptyDataSetSource = self;
    self.mtableview.emptyDataSetDelegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"OrderCell" bundle:nil];
    [self.mtableview registerNib:cellNib forCellReuseIdentifier:OrderCellID];
    
    UINib *headerNib = [UINib nibWithNibName:@"OrderStateHeader" bundle:nil];
    [self.mtableview registerNib:headerNib forHeaderFooterViewReuseIdentifier:OrderStateHeaderID];
    
    //footer register nib
    UINib *footerNib = [UINib nibWithNibName:@"OrderStateFooter" bundle:nil];
    [self.mtableview registerNib:footerNib forHeaderFooterViewReuseIdentifier:OrderStateFooterID];
    
    NSMutableDictionary *ordersParams=[self ordersParams];
    ordersParams[@"orderStatus"] = @[@19,@0,@1,@2,@3,@4,@8,@14];
    [self reqOrdersWithParams:ordersParams];
    
    _mtableview.tableFooterView = [[UIView alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - setup ui
- (void)setupCateGoryView
{
    //全部[19,0,1,2,3,4,8,14] 待提货 1  已完成 3
    self.topview.titles = [NSMutableArray arrayWithObjects:@"全部",@"待提货",@"已完成",nil];
    [self.topview showSeparatorLine];
    [self.topview scrollVisibleTo:0];
    self.topview.normalTextColor = kMainTitleBlackColor;
    self.topview.selectedTextColor = kMainNavigationBarColor;
    self.topview.sliderColor = kMainNavigationBarColor;
    self.topview.sliderWidthPercent = 0.8;
    self.topview.selectedItemTitleBlock = ^(NSInteger idx ,NSString *title){
        NSMutableDictionary *ordersParams= [self ordersParams];
        if (idx == 0) {
            ordersParams[@"orderStatus"] = @[@19,@0,@1,@2,@3,@4,@8,@14];
            [self reqOrdersWithParams:ordersParams];
        }
        if (idx == 1) {
            ordersParams[@"orderStatus"] = @[@1];
            [self reqOrdersWithParams:ordersParams];
        }
        
        if (idx == 2) {
            ordersParams[@"orderStatus"] = @[@3];
            [self reqOrdersWithParams:ordersParams];
        }
    };
}


- (void)showOrderDetailWithModel:(OrderModel*)model{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    OrderDetailTableController *destinationControl = [storyBoard instantiateViewControllerWithIdentifier:@"OrderDetailTableController"];
    destinationControl.orderModel = model;
    [self.navigationController pushViewController:destinationControl animated:YES];
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
    GoodsModel *goodsModel = orderModel.list[indexPath.row];
    [cell updateUIWithModel:goodsModel totalCount:orderModel.list.count row:indexPath.row];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderModel *orderModel = self.ordersArray[section];
    OrderStateFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderStateFooterID];
    [footer setOrderModel:orderModel];
    __block typeof(self) blockSelf = self;
    footer.detailBlock = ^(){
        [blockSelf showOrderDetailWithModel:orderModel];
    };
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderStateHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderStateHeaderID];
    OrderModel *orderModel = self.ordersArray[section];
    [header setOrderModel:orderModel];
    return header;
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


#pragma mark - DZNEmptyDataSetSource Methods
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -144;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if ([RequestUtil networkAvaliable] == NO) {
        NSString *text = @"咦！断网了";
        NSAttributedString *txt = [CommHelper emptyTitleWithTxt:text];
        return txt;
    }else if ((self.ordersArray != nil) && (self.ordersArray.count == 0)){
        [_mtableview.mj_footer setHidden:YES];
        NSString *text = @"暂无订单";
        NSAttributedString *txt = [CommHelper emptyTitleWithTxt:text];
        return txt;
    }else{
        return [[NSAttributedString alloc] init];
    }
}


#pragma mark - requset server
//查询订单参数
- (NSMutableDictionary *)ordersParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    if (self.unionId != nil) {
        params[@"unionId"] = self.unionId;
    }
    params[@"type"] = @"2";
//    params[@"orderStatus"] = @[@0,@1, @2, @3, @10, @11,@19];

    return params;
}

//查询订单
- (void)reqOrdersWithParams:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"order/list";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD dismiss];
//            self.firstReqFinished = YES;
            if (status == StatusTypSuccess) {
                self.ordersArray =  [OrderModel ordersWithData:data];
                if (self.ordersArray.count > 0) {
                    [self.mtableview.mj_footer setHidden:NO];
                }else{
                    [self.mtableview.mj_footer setHidden:YES];
                }
            }else{
                self.ordersArray = [NSMutableArray array];
            }
            [self.mtableview reloadData];
//            [self.mtableview.mj_header endRefreshing];
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showInfoWithStatus:msg];
            [self.mtableview.mj_header endRefreshing];
            self.ordersArray = [NSMutableArray array];
//            self.firstReqFinished = YES;
        }];
    }
}


@end
