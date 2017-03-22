//
//  OrderSuccessController.m
//  PotatoMall
//
//  Created by taotao on 03/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderSuccessController.h"

@interface OrderSuccessController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation OrderSuccessController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController  setToolbarHidden:YES animated:NO];
}

- (void)tapBackBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
