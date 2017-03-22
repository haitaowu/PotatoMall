//
//  PurchaseTableController.m
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "PurchaseTableController.h"
#import "HTCustomeSearchBar.h"
#import "HTSearchHistoryController.h"
#import "PurchaseSearchController.h"
#import "CategoryCell.h"
#import "PurchaseAdsCell.h"
#import "PurSectionHeader.h"
//#import "ProdCateModel.h"
#import "GoodsModel.h"
#import "GoodsCell.h"
#import "PurchHotCell.h"
#import "PurchaseMoresController.h"
#import "ProductDetailTableController.h"
#import "SpringGoodsModel.h"
#import "CateGoryNModel.h"
#import "ChartView.h"


#define kAdvertiseSectionIdx            0
#define kSpringNewSectionIdx            1
#define kProductsSectionIdx             2


static NSString *CategoryCellID = @"CategoryCellID";
static NSString *PurchaseAdsCellID = @"PurchaseAdsCellID";
static NSString *GoodsCellID = @"GoodsCellID";
static NSString *PurchHotCellID = @"PurchHotCellID";


@interface PurchaseTableController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong)NSMutableArray *categoryArray;
@property (nonatomic,strong)NSMutableArray *goodsArray;
@property (nonatomic,strong)NSMutableArray *adsArray;
@property (nonatomic,strong)SpringGoodsModel *springGoodsNew;
@property (nonatomic,strong)SpringGoodsModel *springRecomGoods;
@property (nonatomic,strong)CateGoryNModel *selectedCateModel;
@property (nonatomic,strong)ChartView *chartView;
@property (nonatomic,assign) int pageNo;
@property (nonatomic,assign) int pageSize;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet TopScrollView *topScrollView;
@property (nonatomic,assign) BOOL firstReqFinished;

@end




@implementation PurchaseTableController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.pageNo = 0;
    self.pageSize = 10;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self registerTableNibCell];
    [self setupTableViewFooter];
//    [self requestCategoryData];
    [self requestProductsData];
    [self registerNotifcation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [self.navigationController  setToolbarHidden:YES animated:YES];
    if (self.springRecomGoods.list == nil) {
        [self requestProductsData];
    }
    if ([[UserModelUtil sharedInstance] isUserLogin] == YES) {
        [self updateChartCountLabel];
    }else{
        NSString *chartCount = @"0";
        [self.chartView updateCountWithStr:chartCount];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchGoodsSegue"]) {
        PurchaseSearchController *destinationControl = (PurchaseSearchController*)[segue destinationViewController];
        destinationControl.searchWord = sender;
    }else if ([segue.identifier isEqualToString:@"cateListSegue"]) {
        PurchaseMoresController *destinationControl = (PurchaseMoresController*)[segue destinationViewController];
        destinationControl.cateModel = sender;
    }else if ([segue.identifier isEqualToString:@"productDetailSegue"]) {
        ProductDetailTableController *destinationControl = (ProductDetailTableController*)[segue destinationViewController];
        destinationControl.goodModel = sender;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - setup UI
- (void)registerTableNibCell
{
    UINib *cateNib = [UINib nibWithNibName:@"CategoryCell" bundle:nil];
    [self.tableView registerNib:cateNib forCellReuseIdentifier:CategoryCellID];
    //2 ad cell
    UINib *adsNib = [UINib nibWithNibName:@"PurchaseAdsCell" bundle:nil];
    [self.tableView registerNib:adsNib forCellReuseIdentifier:PurchaseAdsCellID];
    //
    UINib *goodsCellNib = [UINib nibWithNibName:@"GoodsCell" bundle:nil];
    [self.tableView registerNib:goodsCellNib forCellReuseIdentifier:GoodsCellID];
    //
    UINib *hotNib = [UINib nibWithNibName:@"PurchHotCell" bundle:nil];
    [self.tableView registerNib:hotNib forCellReuseIdentifier:PurchHotCellID];
}

- (void)setupUI
{
    __block typeof(self) blockSelf = self;
    HTCustomeSearchBar *searchField = [HTCustomeSearchBar searchbarWithPlaceholder:@"搜索商品" editBlock:^{
        [blockSelf showSearchHistoryView];
    }];
    self.navigationItem.titleView = searchField;
    
    ChartView *chartView = [[ChartView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:chartView];
    self.navigationItem.rightBarButtonItem = rightItem;
    chartView.chartBlock = ^(){
        [blockSelf tapShowChartBtn:nil];
    };
    self.chartView = chartView;
}

- (void)setupTableViewFooter
{
    MJRefreshAutoNormalFooter  *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNo ++;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[kPageNo] = @(self.pageNo);
        params[kPageSize] = @(self.pageSize);
        [self requestMoreProductsWith:params];
    }];
    self.tableView.mj_footer = footer;
    [self.tableView.mj_footer setHidden:YES];
}

#pragma mark - private methods

- (void)registerNotifcation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openProductDetail:) name:kOpenProductLinkNotification object:nil];
}

- (void)updateChartCountLabel
{
    __block typeof(self) blockSelf = self;
    [[UserModelUtil sharedInstance] chartCountWithBlock:^(NSInteger count) {
        NSString *chartCount = [NSString stringWithFormat:@"%ld",count];
        [blockSelf.chartView updateCountWithStr:chartCount];
    }];
}

- (NSArray*)subItemTitlesWithSubItems:(NSArray*)subItems
{
    NSMutableArray *titles = [NSMutableArray array];
    for (CateGoryNModel *obj in subItems) {
        NSString *title = obj.goodsInfoName;
        [titles addObject:title];
    }
    return titles;
}

- (void)setupCateGoryView
{
    NSArray *subItemTitles = [self subItemTitlesWithSubItems:self.categoryArray];
    self.topScrollView.titles = [NSMutableArray arrayWithArray:subItemTitles];
    [self.topScrollView showSeparatorLine];
    [self.topScrollView scrollVisibleTo:0];
    self.topScrollView.normalTextColor = kMainTitleBlackColor;
    self.topScrollView.selectedTextColor = kMainNavigationBarColor;
    self.topScrollView.sliderColor = kMainNavigationBarColor;
    self.topScrollView.sliderWidthPercent = 0.8;
    __block typeof(self) blockSelf = self;
    self.topScrollView.selectedItemTitleBlock = ^(NSInteger idx ,NSString *title){
        if (idx == 0) {
            blockSelf.selectedCateModel = nil;
            [blockSelf.tableView.mj_footer setHidden:NO];
            [blockSelf.tableView reloadData];
        }else{
            blockSelf.selectedCateModel = self.categoryArray[idx];
            blockSelf.tableView.contentOffset = CGPointMake(0, 0);
            [blockSelf reqGoodsWithCategoryModel:self.selectedCateModel];
        }
        HTLog(@"top at scrollview at index title %@",title);
    };

}
#pragma mark - update ui
- (void)showSearchHistoryView
{
    //不使用变量持有它，否则naivationBar的背景色没有办法改变回去。
    HTSearchHistoryController *searchHistoryControl = [[HTSearchHistoryController alloc] init];
    __block typeof(self) blockSelf = self;
    searchHistoryControl.searchBlock = ^(NSString *word){
        [blockSelf performSegueWithIdentifier:@"searchGoodsSegue" sender:word];
    };
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchHistoryControl];
    [self presentViewController:navController animated:NO completion:nil];
}


#pragma mark - private methods
- (void)processProductsData:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSArray *list = dict[@"obj"];
    //采购导航 CGDH
    NSDictionary *cateDict = [self dataWithCode:@"CGDH" list:list];
    self.categoryArray = [CateGoryNModel catesWithData:cateDict];
    
    //采购轮播 CGLB
    NSDictionary *adDict = [self dataWithCode:@"CGLB" list:list];
    NSArray *adsList = [adDict objectForKey:@"list"];
    self.adsArray = [GoodsModel goodsWithArray:adsList];
    
    //更多推荐 GDTJ
    NSDictionary *recommandDict = [self dataWithCode:@"GDTJ" list:list];
    self.springRecomGoods = [SpringGoodsModel goodsWithData:recommandDict];
    
    //春节新上 CJXS
    NSDictionary *springNewDict = [self dataWithCode:@"CJXS" list:list];
    self.springGoodsNew = [SpringGoodsModel goodsWithData:springNewDict];
}

#pragma mark - selectors
- (IBAction)tapShowChartBtn:(id)sender {
    if ([[UserModelUtil sharedInstance] isUserLogin] == YES) {
        [self performSegueWithIdentifier:@"chartSegue" sender:nil];
    }else{
        [self showLoginView];
    }
}

- (id)dataWithCode:(NSString*)codeStr list:(NSArray*)list
{
    for (NSDictionary *obj in list) {
        NSString *code = obj[@"code"];
        if ([code isEqualToString:codeStr]) {
            return obj;
        }
    }
    return [NSDictionary dictionary];
}

#pragma mark - selectors
- (void)openProductDetail:(NSNotification*)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    NSDictionary *userInfo = sender.userInfo;
    GoodsModel *model = userInfo[kNotiUserInfoKey];
    [self performSegueWithIdentifier:@"productDetailSegue" sender:model];
}

#pragma mark - requset server
- (void)requestProductsData
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }else{
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"success", nil];
        NSString *subUrl = @"goods/index";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [self.tableView.mj_header endRefreshing];
            if (status == StatusTypSuccess) {
                [self processProductsData:data];
                [self setupCateGoryView];
                [self.tableView.mj_footer setHidden:NO];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [self.tableView.mj_header endRefreshing];
        }];
    }
}


- (void)requestMoreProductsWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }else{
        NSString *subUrl = @"goods/indexList";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [self.tableView.mj_footer endRefreshing];
            if (status == StatusTypSuccess) {
                NSMutableArray *moreData = [GoodsModel goodsWithData:data];
                [self.springRecomGoods.list addObjectsFromArray:moreData];
            }
            
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [self.tableView.mj_footer endRefreshing];
        }];
    }
}

//按照分类请求的参数
- (NSMutableDictionary*)paramsWithCateModel:(CateGoryNModel*)cateModel
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kCatalogIdKey] = cateModel.url;
    return params;
}

- (void)reqGoodsWithCategoryModel:(CateGoryNModel*)cateModel
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }else{
        self.firstReqFinished = NO;
        [self.tableView reloadData];
        [self.tableView.mj_footer setHidden:YES];
        NSDictionary *params = [self paramsWithCateModel:cateModel];
        NSString *subUrl = @"goods/list";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
//            [SVProgressHUD showInfoWithStatus:msg];
            [self.tableView.mj_header endRefreshing];
            if (status == StatusTypSuccess) {
                self.goodsArray =  [GoodsModel goodsWithData:data];
            }
            self.firstReqFinished = YES;
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [self.tableView.mj_header endRefreshing];
//            [SVProgressHUD showErrorWithStatus:msg];
            self.firstReqFinished = YES;
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([RequestUtil networkAvaliable] == NO) {
        return 0;
    }else{
        if (self.selectedCateModel != nil) {
            return [self.goodsArray count];
        }else{
            //        if (section == kCategorySectionIdx) {
            //            if ([self.categoryArray count] > 0) {
            //                return 1;
            //            }else{
            //                return 0;
            //            }
            //        }else
            if (section == kAdvertiseSectionIdx) {
                if ([self.adsArray count] > 0) {
                    return 1;
                }else{
                    return 0;
                }
            }else if (section == kSpringNewSectionIdx) {
                if ([self.springGoodsNew.list count] > 0) {
                    return 1;
                }else{
                    return 0;
                }
            }else{
                return [self.springRecomGoods.list count] ;
            }
            
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([RequestUtil networkAvaliable] == NO) {
        return 0;
    }else{
         if (self.selectedCateModel != nil) {
             return 1;
         }else{
             return 3;
         }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedCateModel != nil) {
        GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsCellID];
        GoodsModel *model = self.goodsArray[indexPath.row];
        [cell setModel:model];
        return cell;
    }else{
        //     if (indexPath.section == kCategorySectionIdx) {
        //         CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryCellID];
        //         [cell setCategoryArray:self.categoryArray];
        //         __block typeof(self) blockSelf = self;
        //         cell.cateBlock = ^(ProdCateModel *model){
        //             HTLog(@"tap cate block ");
        //             [blockSelf performSegueWithIdentifier:@"cateListSegue" sender:model];
        //         };
        //         return cell;
        //     }else
        if(indexPath.section == kAdvertiseSectionIdx){
            PurchaseAdsCell *cell = [tableView dequeueReusableCellWithIdentifier:PurchaseAdsCellID];
            [cell loadAdsWithModels:self.adsArray];
            __block typeof(self) blockSelf = self;
            cell.adBlock = ^(id sender){
                [blockSelf performSegueWithIdentifier:@"productDetailSegue" sender:sender];
                HTLog(@"tap ads block ");
            };
            return cell;
        }else if(indexPath.section == kProductsSectionIdx){
            GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsCellID];
            GoodsModel *model = self.springRecomGoods.list[indexPath.row];
            [cell setModel:model];
            return cell;
        }else{
            PurchHotCell *cell = [tableView dequeueReusableCellWithIdentifier:PurchHotCellID];
            [cell setSpringHotGoods:self.springGoodsNew.list];
            __block typeof(self) blockSelf = self;
            cell.itemBlock = ^(GoodsModel *model){
                [blockSelf performSegueWithIdentifier:@"productDetailSegue" sender:model];
                HTLog(@"didSelectItemAtIndexPath");
            };
            return cell;
        }
    }
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==  kSpringNewSectionIdx) {
        if ([self.springGoodsNew.list count] > 0) {
            return 40;
        }else{
            return 0.001;
        }
    }else if (section == kProductsSectionIdx){
        if ([self.springRecomGoods.list count] > 0) {
            return 40;
        }else{
            return 0.001;
        }
    }else{
        return 0.001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.selectedCateModel != nil) {
        return 0.001;
    }else{
        if (section ==  kSpringNewSectionIdx) {
            return 15;
        }else{
            return 0.001;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsModel *model;
    if (self.selectedCateModel != nil) {
        model = self.goodsArray[indexPath.row];
    }else{
        model = self.springRecomGoods.list[indexPath.row];
    }
    [self performSegueWithIdentifier:@"productDetailSegue" sender:model];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==  kSpringNewSectionIdx) {
        if ([self.springGoodsNew.list count] > 0) {
            NSString *title = self.springGoodsNew.name;
            PurSectionHeader *titleHeader = [[PurSectionHeader alloc] initWithTitle:title moreTitle:nil];
            titleHeader.moreBlock = ^(){
                HTLog(@"tap more btn ");
            };
            return titleHeader;
        }else{
            return nil;
        }
    }else if (section == kProductsSectionIdx){
        if ([self.springRecomGoods.list count] > 0) {
            NSString *title = self.springRecomGoods.name;
            PurSectionHeader *titleHeader = [[PurSectionHeader alloc] initWithTitle:title moreTitle:nil];
            titleHeader.moreBlock = ^(){
                HTLog(@"tap more btn ");
            };
            return titleHeader;
        }else{
            return nil;
        }
    }else{
        return  nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == kCategorySectionIdx) {
//        CGFloat height = kScrollViewHeight;
//        return height;
//    }else
    
    if (self.selectedCateModel != nil) {
        return 110;
    }else{
        if (indexPath.section == kAdvertiseSectionIdx) {
            CGFloat height = 190;
            return height;
        }else if (indexPath.section == kSpringNewSectionIdx) {
            return 150;
        }else{
            return 110;
        }
    }
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
        NSString *text = @"抱歉，暂时还没有该类别商品";
        NSDictionary *attributes = @{NSFontAttributeName: kEmptyDataTitleFont,
                                     NSForegroundColorAttributeName: UIColorFromRGB(0x888888)};
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }else{
        return [[NSAttributedString alloc] init];
    }
}


@end
