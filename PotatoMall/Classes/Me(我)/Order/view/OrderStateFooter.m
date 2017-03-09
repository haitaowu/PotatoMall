//
//  OrderStateFooter.m
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderStateFooter.h"

@interface OrderStateFooter()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation OrderStateFooter

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark -  setter and getter methods 
- (void)setOrderModel:(OrderModel *)orderModel
{
    _orderModel = orderModel;
    self.dateLabel.text = orderModel.createTime;
    self.priceLabel.text = orderModel.orderPrice;
}

#pragma mark - selectors
- (IBAction)tapMoreBtn:(id)sender {
    if (self.detailBlock != nil) {
        self.detailBlock();
    }
}

@end
