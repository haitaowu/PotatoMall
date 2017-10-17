//
//  OrderStateFooter.h
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

typedef void(^DetailBlock)();
@interface OrderStateFooter : UITableViewHeaderFooterView
@property (nonatomic,strong)OrderModel *orderModel;
@property (nonatomic,copy)DetailBlock  detailBlock;

@end
