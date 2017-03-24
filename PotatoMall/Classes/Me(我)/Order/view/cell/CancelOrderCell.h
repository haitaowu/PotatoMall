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
typedef void(^DeleteOrderBlock)(OrderModel *model);
typedef void(^ReBuyBlock)(OrderModel *model);
typedef void(^ReturnOrderBlock)();
typedef void(^ConfirmRecivedBlock)();

@interface CancelOrderCell : UITableViewCell
@property (nonatomic,copy) OrderModel *model;
@property (nonatomic,copy)CancelBlock  cancelBlock;
@property (nonatomic,copy)PayOrderBlock  payOrderBlock;
@property (nonatomic,copy)DeleteOrderBlock  deleteOrderBlock;
@property (nonatomic,copy)ReBuyBlock  reBuyBlock;
@property (nonatomic,copy)ReturnOrderBlock  retuOrderBlock;
@property (nonatomic,copy)ConfirmRecivedBlock  confirmRecivedBlock;
@end
