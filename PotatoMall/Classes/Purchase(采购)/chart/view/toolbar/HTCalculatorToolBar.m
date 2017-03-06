//
//  HTCalculatorToolBar.m
//  HTCustomToolBarDemo
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HTCalculatorToolBar.h"

@interface HTCalculatorToolBar ()
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *statueBtn;
@property (nonatomic,copy)SelectAllBlock  selectAllBlock;
@property (nonatomic,copy)UnSelectAllBlock  unSelectBlock;
@property (nonatomic,copy)CalculatorBlock  calculatorBlock;

@end


@implementation HTCalculatorToolBar

+ (HTCalculatorToolBar*)customToolBarWithAllBlock:(SelectAllBlock)alBlock unSelectBlock:(UnSelectAllBlock)unSelBlock calculatorBlock:(CalculatorBlock)calcuBlock
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HTCalculatorToolBar" owner:nil options:nil];
    HTCalculatorToolBar *customView = (HTCalculatorToolBar*)[nibView objectAtIndex:0];
    customView.selectAllBlock = alBlock;
    customView.calculatorBlock = calcuBlock;
    customView.unSelectBlock = unSelBlock;
    return customView;
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
