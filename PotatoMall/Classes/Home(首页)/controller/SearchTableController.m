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
#import "AritcleDetailController.h"


static NSString *HotArticleCellID = @"HotArticleCellID";

@interface SearchTableController ()
@property (nonatomic,strong)HTCustomeSearchBar *searchField;
@property (nonatomic,strong)NSMutableArray *articlesArray;
@end

@implementation SearchTableController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self searchArticlsWithKeyWord:self.searchWord];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
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
    self.searchField = searchField;
    self.navigationItem.titleView = searchField;
    [searchField updatePlaceholder:self.searchWord];
    
    //set up tableview
    UINib *articleCellNib = [UINib nibWithNibName:@"HotArticleCell" bundle:nil];
    [self.tableView registerNib:articleCellNib forCellReuseIdentifier:HotArticleCellID];
}

- (void)searchArticlsWithKeyWord:(NSString*)keyword
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kReqType] = @"107";
    params[kSeachKey] = keyword;
    [self requestAritclesWith:params];
}


- (void)showSearchHistoryView
{
    HTSearchHistoryController *searchHistoryControl = [[HTSearchHistoryController alloc] init];
    searchHistoryControl.location = @"home";
    __block typeof(self) blockSelf = self;
    searchHistoryControl.searchBlock = ^(NSString *word){
        [blockSelf.searchField updatePlaceholder:word];
        self.searchWord = word;
        [blockSelf searchArticlsWithKeyWord:word];
        NSLog(@"search word is %@",word);
    };
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchHistoryControl];
    [self presentViewController:navController animated:NO completion:nil];
}

#pragma mark - requset server
- (void)requestAritclesWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }else{
        NSString *subUrl = @"article/list";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD showInfoWithStatus:msg];
            if (status == StatusTypSuccess) {
                self.articlesArray = [ArticleModel articlesWithData:data];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
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
        return 0.001;
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
    return 180;
}

@end
