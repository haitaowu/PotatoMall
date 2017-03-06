//
//  GoodsModel.m
//  PotatoMall
//
//  Created by taotao on 05/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

+ (NSMutableArray*)goodsWithData:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSArray *list = [dict objectForKey:@"obj"];
    NSArray *goods = [GoodsModel mj_objectArrayWithKeyValuesArray:list];
    return [NSMutableArray arrayWithArray:goods];
}

@end
