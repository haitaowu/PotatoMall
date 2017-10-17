//
//  ProdCateModel.m
//  PotatoMall
//
//  Created by taotao on 07/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "ProdCateModel.h"

@implementation ProdCateModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"id",@"cateId", nil];
}

+ (NSMutableArray*)productCategoryesWithData:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSDictionary *list = [dict objectForKey:@"obj"];
    NSArray *array = [ProdCateModel mj_objectArrayWithKeyValuesArray:list];
    return [NSMutableArray arrayWithArray:array];
}

@end
