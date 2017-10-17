//
//  HTSubmitBar.h
//  HTCustomToolBarDemo
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SubmitBlock)();

@interface HTSubmitBar : UIView

+ (HTSubmitBar*)customBarWithAllBlock:(SubmitBlock)submitBlock;
- (void)updateTotalPriceTitle:(NSString*)priceStr;
@end
