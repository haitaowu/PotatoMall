//
//  SearchTableController.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "SearchTableController.h"
#import "HTSearchHistoryController.h"
#import "HTCustomeSearchBar.h"
#import "HotArticleCell.h"


static NSString *HotArticleCellID = @"HotArticleCellID";

@interface SearchTableController ()
@property (nonatomic,strong)HTCustomeSearchBar *searchField;
@end

@implementation SearchTableController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    UINib *articleCellNib = [UINib nibWithNibName:@"HotArticleCell" bundle:nil];
    [self.tableView registerNib:articleCellNib forCellReuseIdentifier:HotArticleCellID];
}


#pragma mark - setup UI
- (void)setupUI
{
    __block typeof(self) blockSelf = self;
    HTCustomeSearchBar *searchField = [HTCustomeSearchBar searchbarWithPlaceholder:@"搜索文章" editBlock:^{
        [blockSelf showSearchHistoryView];
    }];
    self.searchField = searchField;
    self.navigationItem.titleView = searchField;
    [searchField updatePlaceholder:self.searchWord];
    
   
}


- (void)showSearchHistoryView
{
    HTSearchHistoryController *searchHistoryControl = [[HTSearchHistoryController alloc] init];
    __block typeof(self) blockSelf = self;
    searchHistoryControl.searchBlock = ^(NSString *word){
        [blockSelf.searchField updatePlaceholder:word];
        NSLog(@"search word is %@",word);
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
        return 0.001;
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

@end
