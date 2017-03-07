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
#import "ProdCateModel.h"


#define kCategorySectionIdx             0

#define kAdvertiseSectionIdx            1
#define kHotProductsSectionIdx          2
#define kProductsSectionIdx             3


static NSString *CategoryCellID = @"CategoryCellID";

@interface PurchaseTableController ()
@property (nonatomic,strong)NSMutableArray *categoryArray;
@property (nonatomic,strong)NSMutableArray *adsArray;
@property (nonatomic,strong)NSMutableArray *springHotGoods;
@property (nonatomic,strong)NSMutableArray *springGoods;

@end




@implementation PurchaseTableController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self requestCategoryData];
    [self registerTableNibCell];
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
- (void)registerTableNibCell
{
    UINib *cateNib = [UINib nibWithNibName:@"CategoryCell" bundle:nil];
    [self.tableView registerNib:cateNib forCellReuseIdentifier:CategoryCellID];
}

- (void)setupUI
{
    __block typeof(self) blockSelf = self;
    HTCustomeSearchBar *searchField = [HTCustomeSearchBar searchbarWithPlaceholder:@"搜索商品" editBlock:^{
        [blockSelf showSearchHistoryView];
    }];
    self.navigationItem.titleView = searchField;
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
                            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [self.tableView.mj_footer endRefreshing];
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([RequestUtil networkAvaliable] == NO) {
        return 0;
    }else{
        if (section == kCategorySectionIdx) {
            if ([self.categoryArray count] > 0) {
                return 1;
            }else{
                return 0;
            }
        }else if (section == kAdvertiseSectionIdx) {
            if ([self.adsArray count] > 0) {
                return 1;
            }else{
                return 0;
            }
        }else if (section == kHotProductsSectionIdx) {
            if ([self.springHotGoods count] > 0) {
                return 1;
            }else{
                return 0;
            }
        }else{
            return [self.springGoods count] ;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([RequestUtil networkAvaliable] == NO) {
        return 0;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryCellID];
    [cell setCategoryArray:self.categoryArray];
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
//    ArticleModel *model = self.articlesArray[indexPath.row];
//    [self performSegueWithIdentifier:@"detailSegue" sender:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kCategorySectionIdx) {
        CGFloat height = kScrollViewHeight;
        return height;
    }else if (indexPath.section == kAdvertiseSectionIdx) {
        return 180;
    }else if (indexPath.section == kHotProductsSectionIdx) {
        return 180;
    }else{
        return 180;
    }
   
}


@end
