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
#import "PreOrderTableController.h"

#define kDescriptionSectionIdx              0
#define kDescriptionFirstRowIdx             0
#define kDescriptionSecondRowIdx            1

#define kSpecifSectionIdx                   1
#define kSpecifRowIdx                       1

#define kStoreSectionIdx                    2

#define kImageParamsSectionIdx              3

@interface ProductDetailTableController ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusView;
@property (weak, nonatomic) IBOutlet UILabel *moblieDescLabel;
@property (weak, nonatomic) IBOutlet ParamsCell *paramsCell;
@property (weak, nonatomic) IBOutlet ProductSpecificationCell *speciCell;
@property (nonatomic,strong)GoodsDetailModel *goodsDetailModel;
@property (nonatomic,strong)UIImageView *tableheader;

@end

@implementation ProductDetailTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupToolbar];
    [self setupTableviewTableHeader];
    [self reqGoodsInfo];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"preOrderSegue"]) {
        PreOrderTableController *destinationControl = (PreOrderTableController*)[segue destinationViewController];
        destinationControl.goodsArray = sender;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO];
}

#pragma mark - setup UI 
- (void)setupTableviewTableHeader
{
    CGFloat height = kScreenWidth * 2.0 / 3.0;
    CGFloat width = kScreenWidth;
    CGRect tableHeaderF = {{0,0},{width,height}};
    UIImageView *tableheader = [[UIImageView alloc] initWithFrame:tableHeaderF];
    self.tableView.tableHeaderView = tableheader;
    self.tableheader = tableheader;
}

- (void)setupToolbar
{
    __block typeof(self) blockSelf = self;
    HTPurchaseBar *bar = [HTPurchaseBar customBarWithPurchaseBlock:^{
        NSLog(@"purchase  order...");
        [blockSelf performSegueWithIdentifier:@"preOrderSegue" sender:@[self.goodModel]];
    } chartBlock:^{
        NSLog(@"chart  order...");
        [self addGoodsCurrentToChart];
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
    UIImage *placeholder = [UIImage imageNamed:@"hello"];
    NSURL *imgUrl = [NSURL URLWithString:detailModel.imageSrc];
    [self.tableheader sd_setImageWithURL:imgUrl placeholderImage:placeholder];
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

//添加到购物车的请求参数
- (NSDictionary*)chartParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kGoodsInfoIdKey] = self.goodModel.goodsInfoId;
    params[kUserIdKey] = [UserModelUtil sharedInstance].userModel.userId;
    params[kNumKey] = @"1";
    return params;
}


#pragma mark - requset server
- (void)addGoodsCurrentToChart
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }else{
        NSDictionary *params = [self chartParams];
        NSString *subUrl = @"cart/addSingleShopCart";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD showInfoWithStatus:msg];
            if (status == StatusTypSuccess) {
                HTLog(@"add to chart success baby .....");
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == kDescriptionSectionIdx){
        if (indexPath.row == kDescriptionFirstRowIdx) {
            return 120;
        }else{
            return 44;
        }
    }else if(indexPath.section == kSpecifSectionIdx){
        if (indexPath.row == kSpecifRowIdx) {
            NSInteger count = [self.goodsDetailModel.goodsSpecs count];
            return [ProductSpecificationCell cellHieghtWithCount:count];
        }else{
            return 44;
        }
    }else if(indexPath.section == kStoreSectionIdx){
        return 60;
    }else if(indexPath.section == kImageParamsSectionIdx){
        return 250;
    }else{
        return 44;
    }
}
@end
