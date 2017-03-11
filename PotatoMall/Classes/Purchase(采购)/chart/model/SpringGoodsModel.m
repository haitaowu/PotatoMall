//
//  SpringGoodsModel.m
//  PotatoMall
//
//  Created by taotao on 11/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "SpringGoodsModel.h"

@implementation SpringGoodsModel

+ (NSDictionary *)mj_objectClassInArray
{
    NSDictionary *mapDict = @{@"list": @"GoodsModel"};
    return mapDict;
}

+ (SpringGoodsModel*)goodsWithData:(id)data
{
    SpringGoodsModel *goods = [SpringGoodsModel mj_objectWithKeyValues:data];
    return goods;
}


#pragma mark -  setter and getter methods 
- (void)setList:(NSMutableArray *)list
{
    _list = [NSMutableArray arrayWithArray:list];
}

@end
