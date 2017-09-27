//
//  PlanWebViewViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlanWebViewViewController.h"

@interface PlanWebViewViewController ()

@end

@implementation PlanWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"操作帮助";
    NSURL* url = [NSURL URLWithString:_murl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_mwebview loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
