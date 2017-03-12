//
//  OrderDetailTransHeader.m
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderDetailTransHeader.h"

@interface OrderDetailTransHeader()
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;
@property (weak, nonatomic) IBOutlet UILabel *transportModeLabel;
@end

@implementation OrderDetailTransHeader
#pragma mark - override methods
- (void)awakeFromNib
{
    [super awakeFromNib];
}


#pragma mark -  setter and getter methods
- (void)setOrderModel:(OrderModel *)orderModel
{
    _orderModel = orderModel;
    self.remarksLabel.text = orderModel.remark;
    
}

@end
