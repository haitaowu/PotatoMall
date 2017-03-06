//
//  PurchaseSearchController.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "PurchaseSearchController.h"
#import "HTSearchHistoryController.h"
#import "HTCustomeSearchBar.h"
#import "ProductDetailTableController.h"
#import "GoodsModel.h"
#import "GoodsCell.h"


static NSString *GoodsCellID = @"GoodsCellID";

@interface PurchaseSearchController ()
@property (nonatomic,strong)HTCustomeSearchBar *searchField;
@property (nonatomic,strong)NSMutableArray *goodsArray;
@property (weak, nonatomic) IBOutlet UIButton *compreBtn;
@property (weak, nonatomic) IBOutlet UIButton *salesBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy) NSString *priceOrder;
@property (nonatomic,copy) NSString *salesSort;

@end

@implementation PurchaseSearchController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self tapComprehenBtn:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"productDetailSegue"]) {
        ProductDetailTableController *destinationControl = (ProductDetailTableController*)[segue destinationViewController];
        destinationControl.goodModel = sender;
    }
}


#pragma mark - setup UI
- (void)setupUI
{
    __block typeof(self) blockSelf = self;
    HTCustomeSearchBar *searchField = [HTCustomeSearchBar searchbarWithPlaceholder:@"搜索商品" editBlock:^{
        [blockSelf showSearchHistoryView];
    }];
    self.searchField = searchField;
    self.navigationItem.titleView = searchField;
    [searchField updatePlaceholder:self.searchWord];
    
    //set up tableview
    UINib *goodsCellNib = [UINib nibWithNibName:@"GoodsCell" bundle:nil];
    [self.tableView registerNib:goodsCellNib forCellReuseIdentifier:GoodsCellID];
}


- (void)showSearchHistoryView
{
    HTSearchHistoryController *searchHistoryControl = [[HTSearchHistoryController alloc] init];
    __block typeof(self) blockSelf = self;
    searchHistoryControl.searchBlock = ^(NSString *word){
        [blockSelf.searchField updatePlaceholder:word];
        self.searchWord = word;
        [blockSelf submitParamsToReq];
        NSLog(@"search word is %@",word);
    };
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchHistoryControl];
    [self presentViewController:navController animated:NO completion:nil];
}

#pragma mark - selectors
//价格
- (IBAction)tapPriceBtn:(id)sender {
    if (self.priceBtn.selected == YES) {
        if ([self.priceOrder isEqualToString:@"1"]) {
            self.priceOrder = @"0";
        }else{
            self.priceOrder = @"1";
        }
    }else{
        self.priceOrder = @"1";
    }
    self.priceBtn.selected = YES;
    self.salesBtn.selected = NO;
    self.compreBtn.selected = NO;
    [self submitParamsToReq];
}
//销量
- (IBAction)tapSalesBtn:(id)sender {
    if (self.salesBtn.selected == YES) {
        if ([self.salesSort isEqualToString:@"1"]) {
            self.salesSort = @"0";
        }else{
            self.salesSort = @"1";
        }
    }else{
        self.salesSort = @"1";
    }
    self.salesBtn.selected = YES;
    self.priceBtn.selected = NO;
    self.compreBtn.selected = NO;
    [self submitParamsToReq];
}

//综合
- (IBAction)tapComprehenBtn:(id)sender {
    self.priceBtn.selected = NO;
    self.salesBtn.selected = NO;
    self.compreBtn.selected = YES;
    [self submitParamsToReq];
}

#pragma mark - private methods
- (void)submitParamsToReq
{
    NSMutableDictionary *params = [self paramsWithCurrentState];
    [self searchGoodsWith:params];
}

- (NSMutableDictionary*)paramsWithCurrentState
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kKeyWordsKey] = self.searchWord;
    if (self.salesBtn.selected == YES) {
        //销售额排序 1表示升序、0表示降序
        params[kSalesSortKey] =  self.salesSort;
    }else if (self.priceBtn.selected == YES) {
        //价格 1表示升序、0表示降序
         params[kPriceOrderKey] = self.priceOrder;
    }
    
    return params;
}

#pragma mark - requset server
- (void)searchGoodsWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }else{
        NSString *subUrl = @"goods/list";
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.goodsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsCellID];
    GoodsModel *model = self.goodsArray[indexPath.row];
    [cell setModel:model];
    return cell;
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsModel *model = self.goodsArray[indexPath.row];
    [self performSegueWithIdentifier:@"productDetailSegue" sender:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

@end
