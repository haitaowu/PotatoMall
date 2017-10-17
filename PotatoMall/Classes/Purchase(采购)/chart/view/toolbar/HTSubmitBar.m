//
//  HTSubmitBar.m
//  HTCustomToolBarDemo
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HTSubmitBar.h"

@interface HTSubmitBar ()
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *statueBtn;
@property (nonatomic,copy)SubmitBlock  submitBlock;

@end


@implementation HTSubmitBar

+ (HTSubmitBar*)customBarWithAllBlock:(SubmitBlock)submitBlock
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HTSubmitBar" owner:nil options:nil];
    HTSubmitBar *customView = (HTSubmitBar*)[nibView objectAtIndex:0];
    customView.submitBlock = submitBlock;
    return customView;
}

#pragma mark - public methods
- (void)updateTotalPriceTitle:(NSString*)priceStr
{
    self.totalLabel.text = priceStr;
}

#pragma mark - selectors
- (IBAction)tapToCalculator:(id)sender {
    if (self.submitBlock != nil) {
        self.submitBlock();
    }
}


@end
