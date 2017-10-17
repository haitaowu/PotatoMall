//
//  OrderDetailTransHeader.m
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderDetailTransHeader.h"
#import "GoodsModel.h"

@interface OrderDetailTransHeader()
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;
@property (weak, nonatomic) IBOutlet TitleLabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *transportModeLabel;
@property (weak, nonatomic) IBOutlet TitleLabel *orderDateLabel;
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
    
    self.orderDateLabel.text = orderModel.createTime;
    
    NSString *priceStr = [NSString stringWithFormat:@"￥%@",orderModel.orderPrice];
    UIFont *hlFont = [UIFont systemFontOfSize:(self.priceLabel.font.pointSize + 5)];
    NSAttributedString *attriPriceStr = [CommHelper attriWithStr:priceStr keyword:orderModel.orderPrice hlFont:hlFont];
    self.priceLabel.attributedText = attriPriceStr;
    
    
}

@end
