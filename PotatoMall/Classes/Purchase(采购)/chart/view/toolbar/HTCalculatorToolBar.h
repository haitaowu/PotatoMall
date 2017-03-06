//
//  HTCalculatorToolBar.h
//  HTCustomToolBarDemo
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectAllBlock)();
typedef void(^UnSelectAllBlock)();
typedef void(^CalculatorBlock)();

@interface HTCalculatorToolBar : UIView

+ (HTCalculatorToolBar*)customToolBarWithAllBlock:(SelectAllBlock)alBlock unSelectBlock:(UnSelectAllBlock)unSelBlock calculatorBlock:(CalculatorBlock)calcuBlock;
@end
