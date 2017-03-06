//
//  GoodsDetailModel.m
//  PotatoMall
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "GoodsDetailModel.h"

@implementation GoodsDetailModel

+ (GoodsDetailModel*)goodsDetailWithData:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSDictionary *goodsDict = [dict objectForKey:@"obj"];
    GoodsDetailModel *goodsDetail = [GoodsDetailModel mj_objectWithKeyValues:goodsDict];
    return goodsDetail;
}

@end
