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
#import "TopScrollView.h"
#import "ProdCateModel.h"



@interface PurchaseTableController ()
@property (weak, nonatomic) TopScrollView *topScrollView;
@property (nonatomic,strong)NSMutableArray *categoryArray;

@end




@implementation PurchaseTableController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupTableheaderView];
    [self requestCategoryData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController  setToolbarHidden:YES animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchGoodsSegue"]) {
        PurchaseSearchController *destinationControl = (PurchaseSearchController*)[segue destinationViewController];
        destinationControl.searchWord = sender;
    }
}

#pragma mark - setup UI
- (void)setupUI
{
    __block typeof(self) blockSelf = self;
    HTCustomeSearchBar *searchField = [HTCustomeSearchBar searchbarWithPlaceholder:@"搜索商品" editBlock:^{
        [blockSelf showSearchHistoryView];
    }];
    self.navigationItem.titleView = searchField;
}

- (void)setupTableheaderView
{
    //tableView tableHeaderView
    CGFloat height = kScrollViewHeight;
    CGRect frame = CGRectMake(0, 0, kScreenWidth, height);
    TopScrollView *topheader = [[TopScrollView alloc] initWithFrame:frame];
    self.tableView.tableHeaderView = topheader;
    self.topScrollView = topheader;
    self.topScrollView.normalTextColor = kMainTitleBlackColor;
    self.topScrollView.selectedTextColor = kMainNavigationBarColor;
    self.topScrollView.sliderColor = kMainNavigationBarColor;
    self.topScrollView.sliderWidthPercent = 0.8;
    self.topScrollView.selectedItemTitleBlock = ^(NSInteger idx ,NSString *title){
        HTLog(@"top at scrollview at index title %@",title);
    };
}

#pragma mark - update ui
- (void)updateTopScrollViewWithDatas:(NSMutableArray*)datas
{
    NSArray *subItemTitles = [self subItemTitlesWithSubItems:datas];
    self.topScrollView.titles = [NSMutableArray arrayWithArray:subItemTitles];
    [self.topScrollView scrollVisibleTo:0];
}

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
- (NSArray*)subItemTitlesWithSubItems:(NSArray*)subItems
{
    NSMutableArray *titles = [NSMutableArray array];
    for (ProdCateModel *obj in subItems) {
        NSString *title = obj.name;
        [titles addObject:title];
    }
    return titles;
}

#pragma mark - requset server
- (void)requestCategoryData
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }else{
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"0",kParentIdKey, nil];
        NSString *subUrl = @"goods/findCatalogByParentId";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [self.tableView.mj_footer endRefreshing];
            if (status == StatusTypSuccess) {
                self.categoryArray = [ProdCateModel productCategoryesWithData:data];
                [self updateTopScrollViewWithDatas:self.categoryArray];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [self.tableView.mj_footer endRefreshing];
        }];
    }
}


@end
