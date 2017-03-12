//
//  GoodsDetailTableHeader.h
//  PotatoMall
//
//  Created by taotao on 25/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TapAdBlock)(id sender);

@interface GoodsDetailTableHeader : UIView
@property (nonatomic,copy) TapAdBlock adBlock;
- (void)loadAdsWithImages:(id)imgs;

@end
