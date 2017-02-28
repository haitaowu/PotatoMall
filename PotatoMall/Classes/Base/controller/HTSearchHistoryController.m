//
//  HTSearchHistoryController.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HTSearchHistoryController.h"
#import "SeachSectionHeader.h"
#import "SearchCell.h"



static NSString *SearchCellID = @"SearchCellID";

@interface HTSearchHistoryController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,weak)UISearchBar  *searchBar;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation HTSearchHistoryController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *SearchCellNib = [UINib nibWithNibName:@"SearchCell" bundle:nil];
    [self.tableView registerNib:SearchCellNib forCellReuseIdentifier:SearchCellID];
    [self setupSearchBarAppearUI];
    NSArray *array = [[DataUtil shareInstance] queryHomeSerachRecord];
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

-(UISearchBar *)searchBar
{
    if(_searchBar== nil)
    {
        UISearchBar *seabar = [[UISearchBar alloc] init];
        _searchBar  = seabar;
        seabar.width = kScreenWidth * 0.8;
        self.navigationItem.titleView = seabar;
        seabar.placeholder = @"搜索";
        [seabar setShowsCancelButton:YES];
        [seabar setDelegate:self];
        UITextField *txfSearchField = [seabar valueForKey:@"_searchField"];
        txfSearchField.backgroundColor = kHistorySearchBarBGColor;
    }
    return _searchBar;
}

#pragma mark - setup UI 
- (void)setupSearchBarAppearUI
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    self.searchBar.tintColor = kHistorySearchBarTitleColor;
    self.searchBar.barTintColor = kHistorySearchBarTitleColor;
    
    UIImage *img_bg = [UIImage imageNamed:@"nav_bgW"];
    [navBar setBackgroundImage:img_bg forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - private methods
- (void)saveSearchWithTitle:(NSString*)title
{
    BOOL isContained = NO;
    for (NSDictionary *obj in self.dataArray) {
        NSString *word = [obj objectForKey:kColTitle];
        if ([word isEqualToString:title]) {
            isContained = YES;
        }
    }
    if (isContained == NO) {
        [[DataUtil shareInstance] saveHomeSerachRecordWithTitle:title];
    }
}


#pragma mark -  IBaction methods
- (void)tapBackBtn {
    [self setNavigationBarMainStyle];
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self tapBackBtn];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *word = searchBar.text;
    [self tapBackBtn];
    [self saveSearchWithTitle:word];
    if (self.searchBlock != nil) {
        self.searchBlock(word);
    }
}

#pragma mark - UITableView ---  Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchCellID];
    __block typeof(self) blockSelf = self;
    cell.deleteBlock = ^(NSDictionary *record){
        [[DataUtil shareInstance] deleteHomeSerachRecord:record];
        [blockSelf.dataArray removeObject:record];
        [blockSelf.tableView reloadData];
    };
    NSDictionary *model = self.dataArray[indexPath.row];
    [cell setRecord:model];
    return cell;
}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.dataArray count] == 0) {
        return 0.01;
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *record = [self.dataArray objectAtIndex:indexPath.row];
    NSString *word = [record objectForKey:kColTitle];
    [self tapBackBtn];
    if (self.searchBlock != nil) {
        self.searchBlock(word);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SeachSectionHeader *header = [[SeachSectionHeader alloc] init];
    __block typeof(self) blockSelf = self;
    header.deleteAllBlock = ^(){
        [[DataUtil shareInstance] deleteHomeSerachAllRecord];
        blockSelf.dataArray = nil;
        [blockSelf.tableView reloadData];
    };
    return header;
}



@end
