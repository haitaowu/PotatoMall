//
//  OrderDetailStateFooter.m
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderDetailStateFooter.h"

@interface OrderDetailStateFooter()
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;
@property (weak, nonatomic) IBOutlet UILabel *transportModeLabel;
@end

@implementation OrderDetailStateFooter
#pragma mark - override methods
- (void)awakeFromNib
{
    [super awakeFromNib];
}


#pragma mark -  setter and getter methods
- (void)setOrderModel:(OrderModel *)orderModel
{
    _orderModel = orderModel;
}

@end
