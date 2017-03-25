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
    
    //订单状态 0待确认 1未付款 2待提货 3已完成  同意退货:已退单 已提交退货审核:退单审核中...
    if (([orderModel.orderStatus isEqualToString:@"14"]) || ([orderModel.orderStatus isEqualToString:@"8"])) {
        self.stateLabel.textColor = [UIColor redColor];
    }else{
        self.stateLabel.textColor = kMainNavigationBarColor;
    }
}



@end
