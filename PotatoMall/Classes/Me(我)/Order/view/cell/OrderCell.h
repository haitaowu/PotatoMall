//
//  OrderCell.h
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderGoodsModel.h"



@interface OrderCell : UITableViewCell
@property (nonatomic,copy) OrderGoodsModel *model;
@end
