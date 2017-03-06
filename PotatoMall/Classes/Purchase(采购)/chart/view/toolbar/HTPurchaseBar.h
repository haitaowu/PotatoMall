//
//  HTPurchaseBar.h
//  HTCustomToolBarDemo
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PurchaseBlock)();
typedef void(^AddChartBlock)();
typedef void(^ShareBlock)();

@interface HTPurchaseBar : UIView
@property (nonatomic,copy)ShareBlock  shareBlock;

+ (HTPurchaseBar*)customBarWithPurchaseBlock:(PurchaseBlock)purchaseBlock chartBlock:(AddChartBlock)chartBlock;
@end
