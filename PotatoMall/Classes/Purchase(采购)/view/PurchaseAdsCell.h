//
//  PurchaseAdsCell.h
//  PotatoMall
//
//  Created by taotao on 07/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurAdModel.h"

typedef void(^TapAdBlock)(id sender);

@interface PurchaseAdsCell : UITableViewCell
@property (nonatomic,copy) TapAdBlock adBlock;
- (void)loadAdsWithModels:(id)models;

@end
