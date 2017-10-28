//
//  HTPurchaseBar.m
//  HTCustomToolBarDemo
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HTPurchaseBar.h"
#import "VertiImgTitleBtn.h"

@interface HTPurchaseBar ()
@property (weak, nonatomic) VertiImgTitleBtn *shareBtn;
@property (weak, nonatomic) UIButton *addBtn;
@property (weak, nonatomic) UIButton *purBtn;

@property (nonatomic,copy)PurchaseBlock  purchaseBlock;
@property (nonatomic,copy)AddCartBlock  cartBlock;

@end


@implementation HTPurchaseBar

+ (HTPurchaseBar*)customBarWithPurchaseBlock:(PurchaseBlock)purchaseBlock chartBlock:(AddCartBlock)chartBlock
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HTPurchaseBar" owner:nil options:nil];
    HTPurchaseBar *customView = (HTPurchaseBar*)[nibView objectAtIndex:0];
    customView.purchaseBlock = purchaseBlock;
    customView.cartBlock = chartBlock;
    return customView;
}

#pragma mark - override methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize viewSize = CGSizeMake(kScreenWidth, 44);
    CGFloat width = 120;
    
    CGFloat purX = viewSize.width - width;
    CGRect purF = {{purX,0},{width,viewSize.height}};
    self.purBtn.frame = purF;

    CGFloat addX = CGRectGetMinX(purF) - width;
    CGRect addF = {{addX,0},{width,viewSize.height}};
    self.addBtn.frame = addF;
    
    
    CGFloat shareWidth = 60;
    CGRect shareF = {{0,0},{shareWidth,viewSize.height}};
    self.shareBtn.frame = shareF;
    CGFloat margin = 1;
    
    if (@available(iOS 11,*)){
        self.purBtn.x = self.purBtn.x + margin;
        self.addBtn.x = self.addBtn.x + margin;
        self.shareBtn.x = self.shareBtn.x - margin -8;
    }
    
}

#pragma mark - public methods
+ (HTPurchaseBar*)purBarWithBlock:(PurchaseBlock)purBlock cartBlock:(AddCartBlock)cartBlock
{
    HTPurchaseBar *purBar = [[self alloc] initWithPurBlock:purBlock cartBlock:cartBlock];
    return purBar;
}

- (instancetype)initWithPurBlock:(PurchaseBlock)purBlock cartBlock:(AddCartBlock)cartBlock
{
    self = [super init];
    [self setupUI];
    self.purchaseBlock = purBlock;
    self.cartBlock = cartBlock;
    return self;
}


#pragma mark - private methods
- (void)setupUI
{
    self.backgroundColor = [UIColor greenColor];
    
    UIButton *purBtn = [[UIButton alloc] init];
    self.purBtn = purBtn;
    [purBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [purBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    purBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    purBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [purBtn setBackgroundColor:[UIColor redColor]];
    [purBtn addTarget:self action:@selector(tapToCalculator:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:purBtn];
    //
    UIButton *addBtn = [[UIButton alloc] init];
    self.addBtn = addBtn;
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    addBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [addBtn setBackgroundColor:kMainNavigationBarColor];
    [addBtn addTarget:self action:@selector(tapAddChartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    
    VertiImgTitleBtn *shareBtn = [[VertiImgTitleBtn alloc] init];
    self.shareBtn = shareBtn;
    [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"com_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(tapShareToFriendsBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];
    
    self.backgroundColor  = [UIColor greenColor];
}


#pragma mark - selectors
- (IBAction)tapToCalculator:(id)sender {
    if (self.purchaseBlock != nil) {
        self.purchaseBlock();
    }
}

- (IBAction)tapAddChartBtn:(id)sender {
    if (self.cartBlock != nil) {
        self.cartBlock();
    }
}
//share to ur friends
- (IBAction)tapShareToFriendsBtn:(id)sender {
    if (self.shareBlock != nil) {
        self.shareBlock();
    }
}


@end
