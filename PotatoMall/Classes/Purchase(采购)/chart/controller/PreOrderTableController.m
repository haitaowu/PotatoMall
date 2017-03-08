//
//  PreOrderTableController.m
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "PreOrderTableController.h"
#import "CarryCell.h"
#import "ChartCell.h"
#import "OrderPayFooter.h"
#import "OrderFeedCell.h"

static NSString *ChartCellID = @"ChartCellID";
static NSString *CarryCellID = @"CarryCellID";
static NSString *OrderFeedCellID = @"OrderFeedCellID";
static NSString *OrderPayFooterID = @"OrderPayFooterID";


@interface PreOrderTableController ()

@end

@implementation PreOrderTableController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES];
}

#pragma mark - setup UI 

- (void)setupTableView
{
    UINib *cellNib = [UINib nibWithNibName:@"ChartCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:ChartCellID];
    
    UINib *carryCellNib = [UINib nibWithNibName:@"CarryCell" bundle:nil];
    [self.tableView registerNib:carryCellNib forCellReuseIdentifier:CarryCellID];
    
    
    UINib *feedNib = [UINib nibWithNibName:@"OrderFeedCell" bundle:nil];
    [self.tableView registerNib:feedNib forCellReuseIdentifier:OrderFeedCellID];
    
    UINib *footerNib = [UINib nibWithNibName:@"OrderPayFooter" bundle:nil];
    [self.tableView registerNib:footerNib forHeaderFooterViewReuseIdentifier:OrderPayFooterID];
}

#pragma mark - UITableView ---  Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return [self.goodsArray count];
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CarryCell *cell = [tableView dequeueReusableCellWithIdentifier:CarryCellID];
        return cell;
    }else if(indexPath.section == 1){
        ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:ChartCellID];
        GoodsModel *model = self.goodsArray[indexPath.row];
        [cell updateNODeleteWithModel:model];
        cell.deleteBlock = ^(GoodsModel *model){
            [self.goodsArray removeObject:model];
            [self.tableView reloadData];
        };
        return cell;
    }else{
        OrderFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderFeedCellID];
        return cell;
    }
}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }else if(section == 1){
        return 0.001;
    }else{
        return 16;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 16;
    }else if(section == 1){
        return 50;
    }else{
        return 0.001;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }else if(indexPath.section == 1){
        return 150;
    }else{
        return 150;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else if(section == 1){
        OrderPayFooter *payFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderPayFooterID];
        return payFooter;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isMemberOfClass:[OrderPayFooter class]]) {
        ((UITableViewHeaderFooterView *)view).contentView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - UIScorllView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}


@end
