//
//  OrderStateFooter.m
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderStateFooter.h"
#import "GoodsModel.h"

@interface OrderStateFooter()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@end

@implementation OrderStateFooter

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.updateLabel.layer.borderColor = kMainTitleBlackColor.CGColor;
    self.updateLabel.layer.borderWidth = 1;
    self.updateLabel.layer.masksToBounds = YES;
    self.updateLabel.layer.cornerRadius = 5;
}
#pragma mark - private methods
- (NSString*)orderGoodsCount
{
    int count = 0;
    for (GoodsModel *obj in self.orderModel.list) {
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
    if ([orderModel.isUpdate isEqualToString:@"1"]) {
        self.updateLabel.hidden = NO;
    }else{
        self.updateLabel.hidden = YES;
    }
}


#pragma mark - selectors
- (IBAction)tapMoreBtn:(id)sender {
    if (self.detailBlock != nil) {
        self.detailBlock();
    }
}

@end
