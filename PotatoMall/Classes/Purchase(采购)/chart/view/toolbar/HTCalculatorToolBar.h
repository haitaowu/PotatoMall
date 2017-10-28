//
//  HTCalculatorToolBar.h
//  HTCustomToolBarDemo
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    SelectStateTypeAll = 0,
    SelectStateTypeNone,
    SelectStateSelected
}SelectedStateType;

typedef void(^SelectAllBlock)();
typedef void(^UnSelectAllBlock)();
typedef void(^CalculatorBlock)();

@interface HTCalculatorToolBar : UIView

+ (HTCalculatorToolBar*)calculatorBarWithAllBlock:(SelectAllBlock)alBlock unSelectBlock:(UnSelectAllBlock)unSelBlock calculatorBlock:(CalculatorBlock)calcuBlock;
+ (HTCalculatorToolBar*)customToolBarWithAllBlock:(SelectAllBlock)alBlock unSelectBlock:(UnSelectAllBlock)unSelBlock calculatorBlock:(CalculatorBlock)calcuBlock;
- (void)updateTotalPriceTitle:(NSString*)priceStr selectState:(SelectedStateType) state;
@end
