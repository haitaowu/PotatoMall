//
//  OrderDetailTableController.h
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "BaseTableViewController.h"

@class OrderModel;

@interface OrderDetailTableController : BaseTableViewController
@property (nonatomic,strong)OrderModel *orderModel;
@end
