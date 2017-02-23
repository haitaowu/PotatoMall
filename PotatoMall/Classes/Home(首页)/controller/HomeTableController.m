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

@interface HomeTableController ()
@property (nonatomic,weak)HTCustomeSearchBar *searchBar;
@end

@implementation HomeTableController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI
{
    __block typeof(self) blockSelf = self;
    HTCustomeSearchBar *searchField = [HTCustomeSearchBar searchbarWithPlaceholder:@"搜索文章" editBlock:^{
        [blockSelf showSearchHistoryView];
    }];
    self.navigationItem.titleView = searchField;
}

#pragma mark - setup UI
- (void)showSearchHistoryView
{
    HTSearchHistoryController *searchHistory = [[HTSearchHistoryController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchHistory];
    [self presentViewController:navController animated:NO completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}


@end
