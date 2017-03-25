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
#import "SDCycleScrollView.h"
#import "GoodsDetailTableHeader.h"
#import "WXApi.h"
#import "ChartView.h"
#import "HTAlertView.h"


#define kDescriptionSectionIdx              0
#define kDescriptionFirstRowIdx             0
#define kDescriptionSecondRowIdx            1

#define kSpecifSectionIdx                   1
#define kSpecifRowIdx                       1

#define kStoreSectionIdx                    2

#define kImageParamsSectionIdx              3

@interface ProductDetailTableController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusView;
@property (weak, nonatomic) IBOutlet UILabel *moblieDescLabel;
@property (weak, nonatomic) IBOutlet ParamsCell *paramsCell;
@property (weak, nonatomic) IBOutlet ProductSpecificationCell *speciCell;
@property (nonatomic,strong)GoodsDetailModel *goodsDetailModel;
//@property (nonatomic,strong)UIImageView *tableheader;
@property (nonatomic,strong)GoodsDetailTableHeader *headerView;
@property (nonatomic,strong)ChartView *chartView;
@property (nonatomic,assign)CGFloat  paramsCellHeight;
@property (nonatomic,assign)CGFloat  specCellHeight;
@property (nonatomic,strong)HTAlertView  *shareAlertView;

@end

@implementation ProductDetailTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupToolbar];
    [self setupUI];
    [self setBaseInit];
    self.paramsCell.heightBlock = ^(ParamsType type,CGFloat height){
        self.paramsCellHeight = height;
        [self.tableView reloadData];
    };
    
    self.speciCell.cellBlock = ^(CGFloat height){
        self.specCellHeight = height;
        [self.tableView reloadData];
    };
    
    [self setupTableHeaderView];
    
    self.speciCell.specBlock = ^(id specInfo){
        NSString *goodsId = specInfo[kGoodInfoId];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[kGoodsInfoIdKey] = goodsId;
        [self reqGoodsDetailWith:params];
    };
    
//    [self setupTableviewTableHeader];
    [self reqGoodsInfo];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"preOrderSegue"]) {
        PreOrderTableController *destinationControl = (PreOrderTableController*)[segue destinationViewController];
        destinationControl.buyType = kByNow;
        destinationControl.goodsArray = sender;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO];
    NSString *chartCount;
    if ([[UserModelUtil sharedInstance] isUserLogin] == YES) {
        chartCount =  [NSString stringWithFormat:@"%ld",[UserModelUtil sharedInstance].chartCount];
    }else{
        chartCount = @"0";
    }
    [self.chartView updateCountWithStr:chartCount];
}

-(HTAlertView *)shareAlertView
{
    if(_shareAlertView== nil)
    {
        __block typeof(self) blockSelf = self;
        _shareAlertView = [HTAlertView showAleretViewWithFriendsBlock:^{
            [blockSelf shareWithScene:WXSceneSession];
        } allFriendsBlock:^{
            [blockSelf shareWithScene:WXSceneTimeline];
        }];
    }
    return _shareAlertView;
}


#pragma mark - setup UI 
- (void)setupUI
{
    __block typeof(self) blockSelf = self;
    ChartView *chartView = [[ChartView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:chartView];
    self.navigationItem.rightBarButtonItem = rightItem;
    chartView.chartBlock = ^(){
        [blockSelf tapShowChartBtn:nil];
    };
    self.chartView = chartView;
}

- (void)setupTableHeaderView
{
    //tableView tableHeaderView
    GoodsDetailTableHeader *headerView = [[GoodsDetailTableHeader alloc] init];
    CGFloat height = 272.5;
    headerView.frame = CGRectMake(0, 0, kScreenWidth, height);
    self.tableView.tableHeaderView = headerView;
    headerView.adBlock = ^(id adInfo){
    };
    self.headerView = headerView;
}


- (void)setupToolbar
{
    __block typeof(self) blockSelf = self;
    HTPurchaseBar *bar = [HTPurchaseBar customBarWithPurchaseBlock:^{
        NSLog(@"purchase  order...");
        if ([[UserModelUtil sharedInstance] isUserLogin] == YES) {
            [blockSelf performSegueWithIdentifier:@"preOrderSegue" sender:@[self.goodModel]];
        }else{
            [blockSelf showLoginView];
        }
    } chartBlock:^{
        NSLog(@"chart  order...");
        if ([[UserModelUtil sharedInstance] isUserLogin] == YES) {
            [blockSelf addGoodsCurrentToChart];
        }else{
            [blockSelf showLoginView];
        }
    }];
    
    bar.shareBlock = ^(){
        NSLog(@"tap share block ");
        [self.shareAlertView showView];
//        [blockSelf tapShareProduct];
    };
    CGRect frame = self.navigationController.toolbar.frame;
    bar.frame = frame;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:bar];
    self.toolbarItems = @[barItem];
}

#pragma mark - update UI
- (void)updateUIWithDetialModel:(GoodsDetailModel*)detailModel
{
    //描述
//    self.moblieDescLabel.text = detailModel.moblieDesc;
    self.moblieDescLabel.text = detailModel.goodsInfoName;
    //价格
    NSString *priceStr = [NSString stringWithFormat:@"￥%@",detailModel.price];
    UIFont *hlFont = [UIFont systemFontOfSize:(self.priceLabel.font.pointSize + 5)];
    NSAttributedString *attriPriceStr = [CommHelper attriWithStr:priceStr keyword:detailModel.price hlFont:hlFont];
    self.priceLabel.attributedText = attriPriceStr;;
    //当前状态
    [self.statusView setTitle:detailModel.status forState:UIControlStateNormal];
   //轮播图片
    [self.headerView loadAdsWithImages:detailModel.images];
}

#pragma mark - private methods
- (void)setBaseInit
{
    __block typeof(self) blockSelf = self;
    [[UserModelUtil sharedInstance] chartCountWithBlock:^(NSInteger count) {
        NSString *chartCount = [NSString stringWithFormat:@"%ld",count];
        [blockSelf.chartView updateCountWithStr:chartCount];
    }];
}

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

- (void)tapShareProduct{
    if([WXApi isWXAppInstalled]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"分享到朋友圈",@"分享到朋友",nil];
        [actionSheet showInView:self.view];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请安装微信再使用该功能"];
    }
}

#pragma mark - selectors
- (IBAction)tapShowChartBtn:(id)sender {
    if ([[UserModelUtil sharedInstance] isUserLogin] == YES) {
        [self performSegueWithIdentifier:@"chartSegue" sender:nil];
    }else{
        [self showLoginView];
    }
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
            [SVProgressHUD showSuccessWithStatus:@"商品已添加到购物车"];
            if (status == StatusTypSuccess) {
                HTLog(@"add to chart success baby .....");
                [UserModelUtil sharedInstance].chartCount =  [UserModelUtil sharedInstance].chartCount + 1;
                NSString *chartCount = [NSString stringWithFormat:@"%ld",[UserModelUtil sharedInstance].chartCount];
                [self.chartView updateCountWithStr:chartCount];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
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
//            [SVProgressHUD showInfoWithStatus:msg];
            if (status == StatusTypSuccess) {
                self.goodsDetailModel =  [GoodsDetailModel goodsDetailWithData:data];
                [self.paramsCell setDetailModel:self.goodsDetailModel];
                [self updateUIWithDetialModel:self.goodsDetailModel];
                [self.speciCell setDetailModel:self.goodsDetailModel];
            }
            [self.tableView reloadData];
        } reqFail:^(int type, NSString *msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }else if (section == 2) {
        return 0.001;
    }else{
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == kDescriptionSectionIdx){
        if (indexPath.row == kDescriptionFirstRowIdx) {
            CGFloat width = kScreenWidth - 16 * 2;
            CGFloat desHeight = [CommHelper strHeightWithStr:self.goodsDetailModel.goodsInfoName font:self.moblieDescLabel.font width:width];
            return (desHeight + 30 + 16 * 2);
        }else{
            return 0.001;
        }
    }else if(indexPath.section == kSpecifSectionIdx){
        if (indexPath.row == kSpecifRowIdx) {
//            NSInteger count = [self.goodsDetailModel.goodsSpecs count];
//            return [ProductSpecificationCell cellHieghtWithCount:count];
            return self.specCellHeight + 16;
        }else{
            return 30;
        }
    }else if(indexPath.section == kStoreSectionIdx){
        return 0.001;
    }else if(indexPath.section == kImageParamsSectionIdx){
        return self.paramsCellHeight + 80;
    }else{
        return 44;
    }
}

- (void)shareWithScene:(int) scene
{
    if([WXApi isWXAppInstalled]){
        if (scene != -1) {
            NSString *urlStr = [NSString stringWithFormat: @"http://120.25.201.82/tudou/article.html?type=%@&id=%@",kProductSkipType,self.goodModel.goodsInfoId];
            [CommHelper shareUrlWithScene:scene title:self.goodModel.goodsInfoName description:self.goodModel.goodsInfoName imageUrl:self.goodsDetailModel.imageSrc url:urlStr];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请安装微信再使用该功能"];
    }
}


#pragma mark - UIAction sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int scene = -1;
    switch (buttonIndex) {
        case 0:
            scene = WXSceneTimeline;
            break;
        case 1:
            scene = WXSceneSession;
            break;
        default:
            break;
    }
    
    if (scene != -1) {
        NSString *urlStr = [NSString stringWithFormat: @"http://120.25.201.82/tudou/article.html?type=%@&id=%@",kProductSkipType,self.goodModel.goodsInfoId];
        [CommHelper shareUrlWithScene:scene title:self.goodModel.goodsInfoName description:self.goodModel.goodsInfoName imageUrl:self.goodsDetailModel.imageSrc url:urlStr];
    }
}
@end
