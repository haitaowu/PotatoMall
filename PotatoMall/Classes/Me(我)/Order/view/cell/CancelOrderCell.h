//
//  CancelOrderCell.h
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

typedef void(^CancelBlock)();
typedef void(^PayOrderBlock)();

@interface CancelOrderCell : UITableViewCell
@property (nonatomic,copy) OrderModel *model;
@property (nonatomic,copy)CancelBlock  cancelBlock;
@property (nonatomic,copy)PayOrderBlock  payOrderBlock;
@end
