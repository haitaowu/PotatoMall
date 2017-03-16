//
//  HomeTableController.m
//  PotatoMall
//
//  Created by taotao on 22/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HomeTableController.h"
#import "HTSearchHistoryController.h"
#import "HTCustomeSearchBar.h"
#import "SearchTableController.h"
#import "HotArticleCell.h"
#import "SectionHeaderTitle.h"
#import "HomwTableHeader.h"
#import "AritcleDetailController.h"


static NSString *HotArticleCellID = @"HotArticleCellID";

@interface HomeTableController ()
@property (nonatomic,weak)HTCustomeSearchBar *searchBar;

@property (nonatomic,assign) int pageNo;
@property (nonatomic,assign) int pageSize;
@property (nonatomic,strong)NSMutableArray *articlesArray;
@property (nonatomic,strong)HomwTableHeader *headerView;
@end

@implementation HomeTableController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageSize = 10;
    [self setupUI];
    [self setupTableView];
    [self fetchAdsInfo];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchSegue"]) {
        SearchTableController *destinationControl = (SearchTableController*)[segue destinationViewController];
        destinationControl.searchWord = sender;
    }else if ([segue.identifier isEqualToString:@"detailSegue"]) {
        AritcleDetailController *destinationControl = (AritcleDetailController*)[segue destinationViewController];
        destinationControl.paramModel = sender;
    }
}

#pragma mark - setup UI
- (void)setupUI
{
    __block typeof(self) blockSelf = self;
    HTCustomeSearchBar *searchField = [HTCustomeSearchBar searchbarWithPlaceholder:@"搜索文章" editBlock:^{
        [blockSelf showSearchHistoryView];
    }];
    self.navigationItem.titleView = searchField;
}

- (void)setupTableView
{
    UINib *articleCellNib = [UINib nibWithNibName:@"HotArticleCell" bundle:nil];
    [self.tableView registerNib:articleCellNib forCellReuseIdentifier:HotArticleCellID];
    
    [self setupTableheaderView];
    [self setupTableViewHeader];
    [self setupTableViewFooter];
}

- (void)setupTableViewHeader
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNo = 1;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[kPageNo] = @(self.pageNo);
        params[kPageSize] = @(self.pageSize);
        params[kReqType] = @"107";
        [self requestAritclesWith:params];
    }];
    
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupTableViewFooter
{
    MJRefreshAutoNormalFooter  *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNo ++;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[kPageNo] = @(self.pageNo);
        params[kPageSize] = @(self.pageSize);
        params[kReqType] = @"107";
        [self requestMoreArticlesWith:params];
    }];
    self.tableView.mj_footer = footer;
    [self.tableView.mj_footer setHidden:YES];
}

- (void)setupTableheaderView
{
    //tableView tableHeaderView
    HomwTableHeader *headerView = [[HomwTableHeader alloc] init];
//    CGFloat height = kScreenWidth * 236.0 / 315.0;
    CGFloat height = 170.0 ;
    headerView.frame = CGRectMake(0, 0, kScreenWidth, height);
    self.tableView.tableHeaderView = headerView;
    headerView.adBlock = ^(id adInfo){
        HTLog(@"click ad info ");
        [self performSegueWithIdentifier:@"detailSegue" sender:adInfo];
    };
    self.headerView = headerView;
}

- (void)showSearchHistoryView
{
    //不使用变量持有它，否则naivationBar的背景色没有办法改变回去。
    HTSearchHistoryController *searchHistoryControl = [[HTSearchHistoryController alloc] init];
    searchHistoryControl.location = @"home";
    __block typeof(self) blockSelf = self;
    searchHistoryControl.searchBlock = ^(NSString *word){
        [blockSelf performSegueWithIdentifier:@"searchSegue" sender:word];
    };
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchHistoryControl];
    [self presentViewController:navController animated:NO completion:nil];
}

#pragma mark - requset server
- (void)requestMoreArticlesWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }else{
        NSString *subUrl = @"article/list";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [self.tableView.mj_footer endRefreshing];
            if (status == StatusTypSuccess) {
                NSMutableArray *moreData = [ArticleModel articlesWithData:data];
                if ([moreData count] > 0) {
                    [self.articlesArray addObject:moreData];
                }
            }
            
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [self.tableView.mj_footer endRefreshing];
        }];
    }
}

- (void)requestAritclesWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }else{
        NSString *subUrl = @"article/list";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
//            [SVProgressHUD showInfoWithStatus:msg];
            [self.tableView.mj_header endRefreshing];
            if (status == StatusTypSuccess) {
                self.articlesArray = [ArticleModel articlesWithData:data];
                [self.tableView.mj_footer setHidden:NO];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [self.tableView.mj_header endRefreshing];
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

- (void)fetchAdsInfo
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[kReqType] = @"106";
        NSString *subUrl = @"article/list";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
//            [SVProgressHUD showInfoWithStatus:msg];
            if (status == StatusTypSuccess) {
                NSArray *array = [ArticleModel articlesWithData:data];
                [self.headerView loadAdsWithImages:array];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articlesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:HotArticleCellID];
    ArticleModel *model = self.articlesArray[indexPath.row];
    [cell setModel:model];
    return cell;
}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }else{
        return 0.001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleModel *model = self.articlesArray[indexPath.row];
    [self performSegueWithIdentifier:@"detailSegue" sender:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionHeaderTitle *titleHeader = [[SectionHeaderTitle alloc] initWithTitle:@"热门文章"];
    return titleHeader;
}


@end
