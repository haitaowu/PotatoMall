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
    NSDictionary *mapDict = @{@"list": @"OrderGoodsModel"};
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




@end
