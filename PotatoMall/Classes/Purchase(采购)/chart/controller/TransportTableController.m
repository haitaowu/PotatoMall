//
//  TransportTableController.m
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "TransportTableController.h"

@interface TransportTableController ()

@end

@implementation TransportTableController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - selectors
- (IBAction)tapOwnTransportBtn:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.carryLabel.text = @"自提";
    }
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}




@end
