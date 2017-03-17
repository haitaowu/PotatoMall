//
//  BaseViewController.m
//  PotatoMall
//
//  Created by taotao on 25/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end


@implementation BaseViewController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseUI];
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)setupBaseUI
{
    //left navigationBar item
    UIImage *leftImage =[UIImage imageNamed:@"nav_back"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:leftImage forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn addTarget:self action:@selector(tapBackBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -15;
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarItem];
}

#pragma mark - selectors
- (void)tapBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}





@end
