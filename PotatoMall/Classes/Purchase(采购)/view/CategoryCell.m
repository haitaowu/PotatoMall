//
//  CategoryCell.m
//  PotatoMall
//
//  Created by taotao on 07/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "CategoryCell.h"
#import "ProdCateModel.h"

@interface CategoryCell()
@property (weak, nonatomic) IBOutlet TopScrollView *topScrollView;

@end
@implementation CategoryCell

#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupBaseUI];
}

#pragma mark - setup ui
- (void)setupBaseUI
{
}

#pragma mark - update ui
- (void)updateTopScrollViewWithDatas:(NSMutableArray*)datas
{
    NSArray *subItemTitles = [self subItemTitlesWithSubItems:datas];
    self.topScrollView.titles = [NSMutableArray arrayWithArray:subItemTitles];
    [self.topScrollView scrollVisibleTo:0];
    self.topScrollView.normalTextColor = kMainTitleBlackColor;
    self.topScrollView.selectedTextColor = kMainNavigationBarColor;
    self.topScrollView.sliderColor = kMainNavigationBarColor;
    self.topScrollView.sliderWidthPercent = 0.8;
    self.topScrollView.selectedItemTitleBlock = ^(NSInteger idx ,NSString *title){
        HTLog(@"top at scrollview at index title %@",title);
    };
}

#pragma mark -  setter and getter methods 
- (void)setCategoryArray:(NSMutableArray *)categoryArray
{
    if (_categoryArray == nil) {
        [self updateTopScrollViewWithDatas:categoryArray];
        _categoryArray = categoryArray;
    }

}

#pragma mark - private methods
- (NSArray*)subItemTitlesWithSubItems:(NSArray*)subItems
{
    NSMutableArray *titles = [NSMutableArray array];
    for (ProdCateModel *obj in subItems) {
        NSString *title = obj.name;
        [titles addObject:title];
    }
    return titles;
}

@end
