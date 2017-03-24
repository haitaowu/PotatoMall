//
//  TopScrollView.h
//  demo
//
//  Created by taotao on 5/24/16.
//  Copyright © 2016 Mandala. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScrollViewHeight           44



@interface TopScrollView : UIScrollView
@property (nonatomic,strong)NSMutableArray *titles;
@property (nonatomic,copy) void(^selectedItemBlock)(NSInteger);
@property (nonatomic,copy) void(^selectedItemTitleBlock)(NSInteger,NSString *title);
@property (nonatomic,strong)UIColor *normalTextColor;
@property (nonatomic,strong)UIColor *selectedTextColor;
@property (nonatomic,strong)UIColor *sliderColor;
@property (nonatomic,assign) CGFloat sliderWidthPercent;
@property (nonatomic,assign) CGFloat itemWidth;
- (void)scrollVisibleTo:(NSInteger)idx;
- (void)showSeparatorLine;


@end
