//
//  OrderStateHeader.m
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderStateHeader.h"

@interface OrderStateHeader()
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@end

@implementation OrderStateHeader

- (void)awakeFromNib
{
    [super awakeFromNib];
}


#pragma mark -  setter and getter methods
- (void)setOrderModel:(OrderModel *)orderModel
{
    _orderModel = orderModel;
    self.orderNumLabel.text = orderModel.orderCode;
    self.stateLabel.text = [orderModel orderStatusZH];
}


@end
