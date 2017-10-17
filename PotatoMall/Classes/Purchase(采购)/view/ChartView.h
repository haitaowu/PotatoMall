//
//  ChartView.h
//  PotatoMall
//
//  Created by taotao on 16/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TapChartBlock)();

@interface ChartView : UIView

@property (nonatomic,copy)TapChartBlock  chartBlock;
- (void)updateCountWithStr:(NSString*)countStr;

@end
