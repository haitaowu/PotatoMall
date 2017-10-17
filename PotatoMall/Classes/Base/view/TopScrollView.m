//
//  TopScrollView.m
//  demo
//
//  Created by taotao on 5/24/16.
//  Copyright © 2016 Mandala. All rights reserved.
//

#import "TopScrollView.h"
#import "TitleLabel.h"


#define kSliderHeight               4
#define kSubViewsCount              4
#define kScreenSize                 [UIScreen mainScreen].bounds.size


@interface TopScrollView()
@property (nonatomic,strong)NSMutableArray *items;
@property (nonatomic,strong)UIButton *selectedItem;
@property (nonatomic,weak)UIView  *slider;
@property (nonatomic,weak)UIView  *separatorLine;
@end

@implementation TopScrollView

#pragma mark - override methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    
    if (self.separatorLine.hidden == NO){
        CGFloat margin = 150;
        CGSize viewSize = self.frame.size;
        CGFloat width = contentSize.width;
        CGFloat x = - margin;
        CGFloat y = viewSize.height - 0.5;
        CGRect sepF = {{x, y}, {width + margin * 2,0.5}};
        self.separatorLine.frame = sepF;
    }
}


#pragma mark - setup UI
- (void)setupUI
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.sliderWidthPercent = 1;
    UIView *slider = [[UIView alloc] init];
    self.slider = slider;
    [self addSubview:slider];
    slider.backgroundColor = [UIColor redColor];
    
    
    UIView *separatorLine = [[UIView alloc] init];
    self.separatorLine = separatorLine;
    [self addSubview:separatorLine];
    separatorLine.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    separatorLine.alpha = 0.5;
    separatorLine.hidden = YES;
}

#pragma mark - public methods
- (void)showSeparatorLine
{
    self.separatorLine.hidden = NO;
}

#pragma mark -  setter and getter methods
- (void)setNormalTextColor:(UIColor *)normalTextColor
{
    _normalTextColor = normalTextColor;
    [self.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton*)obj;
        [btn setTitleColor:_normalTextColor forState:UIControlStateNormal];
    }];
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor
{
    _selectedTextColor = selectedTextColor;
    [self.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton*)obj;
        [btn setTitleColor:_selectedTextColor forState:UIControlStateSelected];
    }];
}

- (void)setSliderColor:(UIColor *)sliderColor
{
    _sliderColor = sliderColor;
    self.slider.backgroundColor = self.sliderColor;
}

- (void)setSliderWidthPercent:(CGFloat)sliderWidthPercent
{
    if (_sliderWidthPercent >= 1) {
        CGFloat sliderWidth = self.slider.frame.size.width * sliderWidthPercent;
        CGFloat width = self.slider.frame.size.width;
        CGFloat deltaX = (width - sliderWidth) * 0.5;
        CGFloat sliderX = self.slider.frame.origin.x + deltaX;
        CGFloat sliderY = self.slider.frame.origin.y ;
        CGRect sliderFrame = {{sliderX, sliderY}, {sliderWidth,kSliderHeight}};
        self.slider.frame = sliderFrame;
    }
    _sliderWidthPercent = sliderWidthPercent;
}

- (void)setTitles:(NSMutableArray *)titles
{
    _titles = titles;
    if ([titles count] == 1) {
        self.sliderWidthPercent = 0.3;
    }
    if ([self.items count] > 0) {
        [self.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.items removeAllObjects];
    }
    self.items = [NSMutableArray array];
    
    CGFloat itemWidth = 80;
    if (self.itemWidth > 0) {
        itemWidth = self.itemWidth;
    }else{
        if (self.titles.count < kSubViewsCount) {
            itemWidth = kScreenSize.width / self.titles.count;
        }else{
            itemWidth = kScreenSize.width / kSubViewsCount;
        }
    }
    
    CGFloat itemHeight = kScrollViewHeight - kSliderHeight;
    for (int idx = 0 ; idx < titles.count; idx++) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.font = [TitleLabel titleHFont];
        if (idx == 0) {
            btn.selected = YES;
            self.selectedItem = btn;
        }
        
        UIColor *normalColor = (self.normalTextColor == nil?UIColorFromRGB(0x88888888): self.normalTextColor );
        UIColor *selectedColor = (self.selectedTextColor == nil?[UIColor redColor]: self.selectedTextColor );
        [btn setTitleColor:normalColor forState:UIControlStateNormal];
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
        NSString *title = titles[idx];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.tag = idx;
        [btn addTarget:self action:@selector(tapAtItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.items addObject:btn];
        
        // set view frame
        CGFloat x = idx * itemWidth;
        CGRect frame = CGRectMake(x, 0, itemWidth, itemHeight);
        btn.frame = frame;
    }
    
    self.contentSize  = CGSizeMake(self.items.count * itemWidth, kScrollViewHeight * 0.5);
    //slider bar frame
    CGFloat sliderX = 0;
    CGFloat sliderY = kScrollViewHeight - kSliderHeight;
    CGRect sliderFrame = CGRectMake(sliderX, sliderY, itemWidth, kSliderHeight);
    self.slider.frame = sliderFrame;
    
    // set default selected item
    UIButton *selectedItem = [self.items firstObject];
    [self tapAtItem:selectedItem];
}

#pragma mark - private methods
- (void)tapAtItem:(UIButton*)sender
{
    NSInteger idx = sender.tag;
    if (self.selectedItemBlock != nil) {
        self.selectedItemBlock(idx);
    }
    
    if (self.selectedItemTitleBlock != nil) {
        NSString *title = _titles[idx];
        self.selectedItemTitleBlock(idx,title);
    }
    [self scrollVisibleTo:idx];
}

- (void)scrollVisibleTo:(NSInteger)idx
{
    UIButton *item = self.items[idx];
    [self sliderScrollTo:item];
    CGFloat visiableX = item.center.x - kScreenSize.width * 0.5;
    CGRect visibleFrame = CGRectMake(visiableX, 0, kScreenSize.width, 50);
    [self scrollRectToVisible:visibleFrame animated:YES];
    //reselect selected item
    self.selectedItem.selected = NO;
    self.selectedItem = item;
    self.selectedItem.selected = YES;
}


- (void)sliderScrollTo:(UIButton*)sender
{
    CGFloat width = sender.frame.size.width * self.sliderWidthPercent;
    CGFloat btnWidth = sender.frame.size.width;
    CGFloat deltaX = (btnWidth - width) * 0.5;
    //    CGFloat sliderWidth = sender.frame.size.width;
    CGFloat sliderX = sender.frame.origin.x + deltaX;
    CGFloat sliderY =  CGRectGetMaxY(sender.frame);
    CGRect sliderFrame = {{sliderX, sliderY}, {width,kSliderHeight}};
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.frame = sliderFrame;
    }];
}






@end
