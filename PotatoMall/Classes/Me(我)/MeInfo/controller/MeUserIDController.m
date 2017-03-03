//
//  MeUserIDController.m
//  PotatoMall
//
//  Created by taotao on 02/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "MeUserIDController.h"

@interface MeUserIDController()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descrLabel;

@property (nonatomic,weak)UIButton  *farmerView;
@property (nonatomic,weak)UIButton  *purchaserView;

@end


/*类型 
 1:个体种植户
 2：种植企业 
 3：批发商/采购商 
 4：种薯种植企业 
 5：农资电商卖家
 */

@implementation MeUserIDController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScrollUI];
    [self setupSalerView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showRoleViewByCurrentUser];
}

#pragma mark - setup UI 
- (void)showRoleViewByCurrentUser
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    if ([model.userType isEqualToString:@"1"]){
        CGFloat x =  kScreenWidth * 0.5;
        CGFloat y =  0;
        [self.scrollview setContentOffset:CGPointMake(x, y) animated:YES];
    }
}

- (void)setScrollUI
{
    //scrollview content size
    CGFloat width = kScreenWidth + kScreenWidth * 0.5;
    self.scrollview.contentSize = CGSizeMake(width, 0);
    
    //scrollview subviews
    CGFloat imagePerc = 1;
    CGSize scrollSize = self.scrollview.bounds.size;
    CGFloat imgWH = scrollSize.height * imagePerc;
    //login_saler purchase
    UIImage *purchaseImg = [UIImage imageNamed:@"login_saler"];
    UIImage *purchaseImgSel = [UIImage imageNamed:@"login_saler_sel"];
    UIButton *purchaseBtn = [[UIButton alloc] init];
    [purchaseBtn setBackgroundImage:purchaseImg forState:UIControlStateNormal];
    [purchaseBtn setBackgroundImage:purchaseImgSel forState:UIControlStateSelected];
    purchaseBtn.tag = 3;
    [purchaseBtn addTarget:self action:@selector(selectRole:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:purchaseBtn];
    self.purchaserView = purchaseBtn;
    CGFloat y = (scrollSize.height - imgWH) * 0.5;
    CGFloat purchX = (scrollSize.width - imgWH) * 0.5;
    CGRect purchaseF = {{purchX,y},{imgWH,imgWH}};
    purchaseBtn.frame = purchaseF;
    
    //farmer view
    UIImage *farmerImg = [UIImage imageNamed:@"login_farmer"];
    UIImage *farmerImgSel = [UIImage imageNamed:@"login_farmer_sel"];
    UIButton *farmerBtn = [[UIButton alloc] init];
    [farmerBtn setBackgroundImage:farmerImg forState:UIControlStateNormal];
    [farmerBtn setBackgroundImage:farmerImgSel forState:UIControlStateSelected];
    farmerBtn.tag = 1;
    [farmerBtn addTarget:self action:@selector(selectRole:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:farmerBtn];
    self.farmerView = farmerBtn;
    CGFloat farmerY = y;
    CGFloat farmerX = width - purchX - imgWH;
    CGRect farmerF = {{farmerX,farmerY},{imgWH,imgWH}};
    farmerBtn.frame = farmerF;
    
}

- (void)setupSalerView
{
    self.farmerView.selected = NO;
    self.farmerView.alpha = 0.3;
    self.purchaserView.selected = YES;
    self.purchaserView.alpha = 1;
    self.titleLabel.text = @"马铃薯采购商";
    self.descrLabel.text = @"从事马铃薯批发/采购的个人或者企业";
}

- (void)setupFarmerView
{
    self.farmerView.selected = YES;
    self.farmerView.alpha = 1;
    self.purchaserView.selected = NO;
    self.purchaserView.alpha = 0.3;
    self.titleLabel.text = @"马铃薯种植户";
    self.descrLabel.text = @"以个人或家庭为单位的马铃薯种植户";
}

#pragma mark - selector
- (void)selectRole:(UIButton*)sender
{
}

//选择角色进入下一步
- (IBAction)tapNextStepBtn:(id)sender {
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    if (self.farmerView.selected == YES){
        model.userType = @"1";
    }else{
        model.userType = @"3";
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    HTLog(@"scrollView did Scroll...");
    CGFloat scrollWidth = scrollView.bounds.size.width;
    CGFloat contentX = scrollView.contentOffset.x;
    CGFloat boundarX = scrollWidth * 0.5;
    if (contentX >= boundarX) {
        [self setupFarmerView];
    }else{
        [self setupSalerView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    CGFloat scrollWidth = scrollView.bounds.size.width;
//    CGFloat contentX = scrollView.contentOffset.x;
//    CGFloat boundarX = scrollWidth * 0.5;
//    if (contentX >= boundarX) {
//        [self setupFarmerView];
//    }else{
//        [self setupSalerView];
//    }
}




@end
