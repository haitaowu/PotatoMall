//
//  HTCalculatorToolBar.m
//  HTCustomToolBarDemo
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HTCalculatorToolBar.h"

@interface HTCalculatorToolBar ()
@property (weak, nonatomic)  UIButton *statueBtn;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic)  UILabel *totalLabel;
@property (weak, nonatomic)  UIButton *calculatorBtn;
@property (nonatomic,copy)SelectAllBlock  selectAllBlock;
@property (nonatomic,copy)UnSelectAllBlock  unSelectBlock;
@property (nonatomic,copy)CalculatorBlock  calculatorBlock;

@end


@implementation HTCalculatorToolBar

#pragma mark - override methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize viewSize = CGSizeMake(kScreenWidth, 44);
    CGFloat statueWidth = 60;
    
    CGFloat statueX = 0;
    CGRect stateF = {{statueX,0},{statueWidth,viewSize.height}};
    self.statueBtn.frame = stateF;
    
    [self.titleLabel sizeToFit];
    CGSize titleSize = self.titleLabel.size;
    CGFloat titleX = CGRectGetMaxX(stateF);
    CGFloat titleY = (viewSize.height - titleSize.height) * 0.5;
    CGRect titleF = {{titleX,titleY},titleSize};
    self.titleLabel.frame = titleF;
    
    [self.totalLabel sizeToFit];
    CGSize totalSize = self.totalLabel.size;
    CGFloat totalX = CGRectGetMaxX(titleF);
    CGFloat totalY = (viewSize.height - totalSize.height) * 0.5;
    CGRect totalF = {{totalX,totalY},totalSize};
    self.totalLabel.frame = totalF;
    
    CGFloat calWidth = 120;
    CGFloat calX = viewSize.width - calWidth;
    CGRect calF = {{calX,0},{calWidth,viewSize.height}};
    self.calculatorBtn.frame = calF;

    CGFloat margin = 1;
    
    if (@available(iOS 11,*)){
        self.calculatorBtn.x = self.calculatorBtn.x + margin;
        self.statueBtn.x = self.statueBtn.x - 16;
    }
}

#pragma mark - public methods
+ (HTCalculatorToolBar*)calculatorBarWithAllBlock:(SelectAllBlock)alBlock unSelectBlock:(UnSelectAllBlock)unSelBlock calculatorBlock:(CalculatorBlock)calcuBlock
{
    HTCalculatorToolBar *bar = [[self alloc] initBarWithAllBlock:alBlock unSelectBlock:unSelBlock calculatorBlock:calcuBlock];
    return bar;
}


- (HTCalculatorToolBar*)initBarWithAllBlock:(SelectAllBlock)alBlock unSelectBlock:(UnSelectAllBlock)unSelBlock calculatorBlock:(CalculatorBlock)calcuBlock
{
    self = [super init];
    [self setupUI];
    self.selectAllBlock = alBlock;
    self.calculatorBlock = calcuBlock;
    self.unSelectBlock = unSelBlock;
    return self;
}


+ (HTCalculatorToolBar*)customToolBarWithAllBlock:(SelectAllBlock)alBlock unSelectBlock:(UnSelectAllBlock)unSelBlock calculatorBlock:(CalculatorBlock)calcuBlock
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HTCalculatorToolBar" owner:nil options:nil];
    HTCalculatorToolBar *customView = (HTCalculatorToolBar*)[nibView objectAtIndex:0];
    customView.selectAllBlock = alBlock;
    customView.calculatorBlock = calcuBlock;
    customView.unSelectBlock = unSelBlock;
    return customView;
}


- (void)updateTotalPriceTitle:(NSString*)priceStr selectState:(SelectedStateType) state 
{
    self.totalLabel.text = priceStr;
    if(state == SelectStateTypeNone){
        self.statueBtn.selected = NO;
    }else if(state == SelectStateTypeAll){
        self.statueBtn.selected = YES;
    }
    [self setNeedsLayout];
}


#pragma mark - private methods
- (void)setupUI
{
    UIButton *statueBtn = [[UIButton alloc] init];
    self.statueBtn = statueBtn;
    [statueBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    statueBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [statueBtn setTitle:@"全选" forState:UIControlStateNormal];
    [statueBtn setImage:[UIImage imageNamed:@"chart_unSelect"] forState:UIControlStateNormal];
    [statueBtn setImage:[UIImage imageNamed:@"chart_select"] forState:UIControlStateSelected];
    [statueBtn addTarget:self action:@selector(tapSelectAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    statueBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    [self addSubview:statueBtn];
    
    
    //
    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    titleLabel.text = @"合计：￥";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
    
    UILabel *totalLabel = [[UILabel alloc] init];
    self.totalLabel = totalLabel;
    totalLabel.text = @"0";
    totalLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:totalLabel];
    
    UIButton *calculatorBtn = [[UIButton alloc] init];
    self.calculatorBtn = calculatorBtn;
    [calculatorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [calculatorBtn setTitle:@"结算" forState:UIControlStateNormal];
    calculatorBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    calculatorBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [calculatorBtn setBackgroundColor:[UIColor redColor]];
    [calculatorBtn addTarget:self action:@selector(tapToCalculator:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:calculatorBtn];
    
}

#pragma mark - selectors
- (IBAction)tapToCalculator:(id)sender {
    if (self.calculatorBlock != nil) {
        self.calculatorBlock();
    }
}

- (IBAction)tapSelectAllBtn:(id)sender {
    self.statueBtn.selected = !self.statueBtn.selected;
    if (self.statueBtn.selected == YES) {
        if (self.selectAllBlock != nil) {
            self.selectAllBlock();
        }
    }else{
        if (self.unSelectBlock != nil) {
            self.unSelectBlock();
        }
    }
}

@end
