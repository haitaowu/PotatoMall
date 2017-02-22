//
//  HomeTableController.m
//  PotatoMall
//
//  Created by taotao on 22/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HomeTableController.h"

@interface HomeTableController ()

@end

@implementation HomeTableController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
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
