//
//  OrderModel.m
//  PotatoMall
//
//  Created by taotao on 09/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+ (NSDictionary *)mj_objectClassInArray
{
    NSDictionary *mapDict = @{@"list": @"GoodsModel"};
    return mapDict;
}



+ (NSMutableArray*)ordersWithData:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSArray *obj = [dict objectForKey:@"obj"];
    return [self ordersWithArray:obj];
}

+ (NSMutableArray*)ordersWithArray:(id)data
{
    NSArray *orders = [OrderModel mj_objectArrayWithKeyValuesArray:data];
    return [NSMutableArray arrayWithArray:orders];
}


#pragma mark - override methods
/* *0未付款 1已付款未发货 2已发货 3已经收货 4作废 7:退货审核中 8：同意退货 9:拒绝退货 10:待商家收货 11:订单结束 12:同意退款 * 13： 拒绝退款 14:已提交退货审核 15：已提交退款审核 16: 商家收货失败 17:已退款 18:申请退款 退款成功
 */

- (NSString*)orderStatusZH
{
    NSDictionary *keyValues = [NSDictionary dictionaryWithObjectsAndKeys:@"未付款",@"0",@"已付款未发货",@"1",@"已发货",@"2",@"已经收货",@"3",@"作废",@"4",@"退货审核中",@"7",@"同意退货",@"8",@"拒绝退货",@"9",@"待商家收货",@"10",@"订单结束",@"11",@"同意退款",@"12",@"拒绝退款",@"13",@"已提交退货审核",@"14",@"已提交退款审核",@"15",@"商家收货失败",@"16",@"已退款",@"17",@"退款成功",@"18", nil];
    NSString *zhStr = [keyValues objectForKey:self.orderStatus];
    return zhStr;
}


@end
