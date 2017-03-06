//
//  HTPurchaseBar.m
//  HTCustomToolBarDemo
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HTPurchaseBar.h"

@interface HTPurchaseBar ()
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *statueBtn;
@property (nonatomic,copy)PurchaseBlock  purchaseBlock;
@property (nonatomic,copy)AddChartBlock  chartBlock;

@end


@implementation HTPurchaseBar

+ (HTPurchaseBar*)customBarWithPurchaseBlock:(PurchaseBlock)purchaseBlock chartBlock:(AddChartBlock)chartBlock
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HTPurchaseBar" owner:nil options:nil];
    HTPurchaseBar *customView = (HTPurchaseBar*)[nibView objectAtIndex:0];
    customView.purchaseBlock = purchaseBlock;
    customView.chartBlock = chartBlock;
    return customView;
}

#pragma mark - selectors
- (IBAction)tapToCalculator:(id)sender {
    if (self.purchaseBlock != nil) {
        self.purchaseBlock();
    }
}

- (IBAction)tapAddChartBtn:(id)sender {
    if (self.chartBlock != nil) {
        self.chartBlock();
    }
}
//share to ur friends
- (IBAction)tapShareToFriendsBtn:(id)sender {
    if (self.shareBlock != nil) {
        self.shareBlock();
    }
}


@end
