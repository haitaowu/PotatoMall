//
//  HTSearchHistoryController.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HTSearchHistoryController.h"

@interface HTSearchHistoryController ()
@property (nonatomic,weak)UISearchBar  *searchBar;
@end

@implementation HTSearchHistoryController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - setup UI 
- (void)setupUI
{
    // searchar
    UISearchBar *searchbar = [[UISearchBar alloc] init];
    searchbar.width = kScreenWidth * 0.8;
    self.navigationItem.titleView = searchbar;
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor whiteColor]];
    
    searchbar.placeholder = @"搜索";
    [searchbar setShowsCancelButton:YES];
    [searchbar setDelegate:self];
    self.searchBar = searchbar;
    
    searchbar.tintColor = kHistorySearchBarTitleColor;
    searchbar.barTintColor = kHistorySearchBarTitleColor;
    
    UITextField *txfSearchField = [searchbar valueForKey:@"_searchField"];
    txfSearchField.backgroundColor = kHistorySearchBarBGColor;
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




@end
