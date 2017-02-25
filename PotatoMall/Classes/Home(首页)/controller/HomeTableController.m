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


static NSString *HotArticleCellID = @"HotArticleCellID";

@interface HomeTableController ()
@property (nonatomic,weak)HTCustomeSearchBar *searchBar;
@end

@implementation HomeTableController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    UINib *articleCellNib = [UINib nibWithNibName:@"HotArticleCell" bundle:nil];
    [self.tableView registerNib:articleCellNib forCellReuseIdentifier:HotArticleCellID];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchSegue"]) {
        SearchTableController *destinationControl = (SearchTableController*)[segue destinationViewController];
        destinationControl.searchWord = sender;
    }else if ([segue.identifier isEqualToString:@"detailSegue"]) {
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
    [self setupTableheaderView];
}

- (void)setupTableheaderView
{
    //tableView tableHeaderView
    HomwTableHeader *headerView = [[HomwTableHeader alloc] init];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    NSArray *imgs = @[@"http://static.xianzhongwang.com/Fi0kG4sv9RVle3hMudh6WVcoQUdo",@"http://static.xianzhongwang.com/Fi0kG4sv9RVle3hMudh6WVcoQUdo",@"http://static.xianzhongwang.com/Fi0kG4sv9RVle3hMudh6WVcoQUdo"];
    [headerView loadAdsWithImages:imgs];
    self.tableView.tableHeaderView = headerView;
    headerView.adBlock = ^(id adInfo){
        HTLog(@"click ad info ");
    };
}

- (void)showSearchHistoryView
{
    //不使用变量持有它，否则naivationBar的背景色没有办法改变回去。
    HTSearchHistoryController *searchHistoryControl = [[HTSearchHistoryController alloc] init];
    __block typeof(self) blockSelf = self;
    searchHistoryControl.searchBlock = ^(NSString *word){
        [blockSelf performSegueWithIdentifier:@"searchSegue" sender:word];
    };
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchHistoryControl];
    [self presentViewController:navController animated:NO completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:HotArticleCellID];
    return cell;
}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50;
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
    [self performSegueWithIdentifier:@"detailSegue" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionHeaderTitle *titleHeader = [[SectionHeaderTitle alloc] initWithTitle:@"热门文章"];
    return titleHeader;
}


@end
