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
#import "PreOrderTableController.h"


static NSString *ChartCellID = @"ChartCell";
static NSString *HeaderID = @"HeaderID";

@interface ChartTableController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong)HTCalculatorToolBar *toolBar;
@property (nonatomic,strong)NSMutableArray *goodsArray;
@property (nonatomic,strong)NSMutableArray *selectedGoods;
@property (nonatomic,assign) BOOL firstReqFinished;
@end

@implementation ChartTableController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.firstReqFinished = NO;
    [self reqGoodsData];
    [self setupNavToolbar];
    [self.navigationController  setToolbarHidden:NO animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"preOrderSegue"]) {
        PreOrderTableController *destinationControl = (PreOrderTableController*)[segue destinationViewController];
        destinationControl.goodsArray = sender;
    }
}

#pragma mark - lazy methods
-(NSMutableArray *)selectedGoods
{
    if(_selectedGoods== nil)
    {
        _selectedGoods = [[NSMutableArray alloc] init];
    }
    return _selectedGoods;
}


#pragma mark - setup UI 
- (void)setupNavToolbar
{
    [self.navigationController  setToolbarHidden:NO animated:YES];
    HTCalculatorToolBar *toolbar = [HTCalculatorToolBar customToolBarWithAllBlock:^{
        self.selectedGoods = [NSMutableArray arrayWithArray:self.goodsArray];
        [self selectedAllGoods];
        [self updateTotalPriceLabel];
    } unSelectBlock:^{
        [self.selectedGoods removeAllObjects];
        [self unSelectedAllGoods];
        [self updateTotalPriceLabel];
    } calculatorBlock:^{
        if ([self.selectedGoods count] > 0) {
            [self performSegueWithIdentifier:@"preOrderSegue" sender:self.selectedGoods];
        }
    }];
    
    CGRect frame = self.navigationController.toolbar.frame;
    toolbar.frame = frame;
    self.toolBar = toolbar;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    self.toolbarItems = @[barItem];
}

- (void)setupTableView
{
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"ChartCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:ChartCellID];
    
    UINib *headerNib = [UINib nibWithNibName:@"ChartSectionHeader" bundle:nil];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:HeaderID];
}
#pragma mark -  private methods 
- (void)unSelectedAllGoods
{
    for (GoodsModel *obj in self.goodsArray) {
        obj.isSelected = NO;
    }
    [self.tableView reloadData];
}

- (void)selectedAllGoods
{
    for (GoodsModel *obj in self.goodsArray) {
        obj.isSelected = YES;
    }
    [self.tableView reloadData];
}

#pragma mark - update UI 
- (void)updateTotalPriceLabel
{
    CGFloat totalPrice = 0;
    for (GoodsModel *obj in self.selectedGoods) {
        totalPrice += [self calculatorPriceWithModel:obj];
    }
    NSString *priceStr = [NSString stringWithFormat:@"%.2f",totalPrice];
    if ([self.selectedGoods count] == 0) {
        [self.toolBar updateTotalPriceTitle:priceStr selectState:SelectStateTypeNone];
    }else if ([self.selectedGoods count] == [self.goodsArray count]) {
        [self.toolBar updateTotalPriceTitle:priceStr selectState:SelectStateTypeAll];
    }else{
        [self.toolBar updateTotalPriceTitle:priceStr selectState:SelectStateSelected];
    }
}

- (CGFloat)calculatorPriceWithModel:(GoodsModel*)model
{
    NSInteger count = [model.selectedCount integerValue];
    CGFloat price = [model.price floatValue];
    CGFloat totalPrice = price * count;
    return totalPrice;
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
            self.firstReqFinished = YES;
            if (status == StatusTypSuccess) {
                self.goodsArray =  [GoodsModel goodsWithData:data];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            self.firstReqFinished = YES;
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

- (void)deleteWithGoodsModel:(GoodsModel*)goodsModel
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        id userId = [UserModelUtil sharedInstance].userModel.userId;
        params[kUserIdKey] = userId;
        params[kGoodsInfoIdsKey] = goodsModel.goodsInfoId;
        NSString *subUrl = @"cart/deleteCartProduct";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD showInfoWithStatus:msg];
            if (status == StatusTypSuccess) {
                [self.goodsArray removeObject:goodsModel];
                [self.selectedGoods removeObject:goodsModel];
                [self updateTotalPriceLabel];
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
    __block typeof(self) blockSelf = self;
    cell.deleteBlock = ^(GoodsModel *model){
        [blockSelf deleteWithGoodsModel:model];
    };
    
    cell.selectBlock = ^(GoodsModel *model){
        [blockSelf.selectedGoods addObject:model];
        [blockSelf updateTotalPriceLabel];
        HTLog(@"selected a goods");
    };
    
    cell.unSelectBlock = ^(GoodsModel *model){
        [blockSelf.selectedGoods removeObject:model];
        [blockSelf updateTotalPriceLabel];
        HTLog(@"unselected a goods");
    };
    
    cell.countBlock= ^(GoodsModel *model){
        HTLog(@"selected a goods");
        [blockSelf updateTotalPriceLabel];
    };
    return cell;
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    return 50;
    return 0.001;
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
    return 120;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    ChartSectionHeader *titleHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderID];
//    return titleHeader;
//}

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
    }else if ((self.firstReqFinished == YES) && (self.goodsArray.count <= 0)){
        NSString *text = @"你的购物车现在空空如也";
        NSDictionary *attributes = @{NSFontAttributeName: kEmptyDataTitleFont,
                                     NSForegroundColorAttributeName: UIColorFromRGB(0x888888)};
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }else{
        return [[NSAttributedString alloc] init];
    }
}

@end
