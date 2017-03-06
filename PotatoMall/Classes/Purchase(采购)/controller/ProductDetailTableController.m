//
//  ProductDetailTableController.m
//  PotatoMall
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "ProductDetailTableController.h"
#import "HTPurchaseBar.h"
#import "GoodsDetailModel.h"
#import "ParamsCell.h"
#import "ProductSpecificationCell.h"

@interface ProductDetailTableController ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusView;
@property (weak, nonatomic) IBOutlet UILabel *moblieDescLabel;
@property (weak, nonatomic) IBOutlet ParamsCell *paramsCell;
@property (weak, nonatomic) IBOutlet ProductSpecificationCell *speciCell;
@property (nonatomic,strong)GoodsDetailModel *goodsDetailModel;

@end

@implementation ProductDetailTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupToolbar];
    [self reqGoodsInfo];
}

#pragma mark - setup UI 
- (void)setupToolbar
{
    [self.navigationController setToolbarHidden:NO];
    HTPurchaseBar *bar = [HTPurchaseBar customBarWithPurchaseBlock:^{
        NSLog(@"purchase  order...");
    } chartBlock:^{
        NSLog(@"chart  order...");
    }];
    
    bar.shareBlock = ^(){
        NSLog(@"tap share block ");
    };
    CGRect frame = self.navigationController.toolbar.frame;
    bar.frame = frame;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:bar];
    self.toolbarItems = @[barItem];
}
#pragma mark - update UI
- (void)updateUIWithDetialModel:(GoodsDetailModel*)detailModel
{
    self.moblieDescLabel.text = detailModel.moblieDesc;
    self.priceLabel.text = detailModel.price;
    [self.statusView setTitle:detailModel.status forState:UIControlStateNormal];
}

#pragma mark - private methods
- (void)reqGoodsInfo
{
    if(self.goodModel != nil){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[kGoodsInfoIdKey] = self.goodModel.goodsInfoId;
        [self reqGoodsDetailWith:params];
    }
}

#pragma mark - requset server
- (void)reqGoodsDetailWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }else{
        NSString *subUrl = @"goods/detail";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD showInfoWithStatus:msg];
            if (status == StatusTypSuccess) {
                self.goodsDetailModel =  [GoodsDetailModel goodsDetailWithData:data];
                [self.paramsCell setDetailModel:self.goodsDetailModel];
                [self updateUIWithDetialModel:self.goodsDetailModel];
                [self.speciCell setDetailModel:self.goodsDetailModel];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

@end
