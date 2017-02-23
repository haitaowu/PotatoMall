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
    [self setupSearchBarAppearUI];
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
    [navBar setBarTintColor:[UIColor whiteColor]];
    self.searchBar.tintColor = kHistorySearchBarTitleColor;
    self.searchBar.barTintColor = kHistorySearchBarTitleColor;
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
    if (self.searchBlock != nil) {
        [self tapBackBtn];
        self.searchBlock(word);
    }
    
}



@end
