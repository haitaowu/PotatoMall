//
//  OrderDetailFooter.m
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderDetailFooter.h"
#import "OrderGoodsModel.h"

@interface OrderDetailFooter()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@end

@implementation OrderDetailFooter

- (void)awakeFromNib
{
    [super awakeFromNib];
}
#pragma mark - private methods
- (NSString*)orderGoodsCount
{
    int count = 0;
    for (OrderGoodsModel *obj in self.orderModel.list) {
        count += [obj.num intValue];;
    }
    NSString *countStr = [NSString stringWithFormat:@"%d",count];
    return countStr;
}

#pragma mark -  setter and getter methods
- (void)setOrderModel:(OrderModel *)orderModel
{
    _orderModel = orderModel;
    self.dateLabel.text = orderModel.createTime;
    self.priceLabel.text = orderModel.orderPrice;
    
    NSString *countStr = [self orderGoodsCount];
    self.countLabel.text = [NSString stringWithFormat:@"共%@件商品",countStr];
}



@end
