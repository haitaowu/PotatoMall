//
//  CateGoryNModel.m
//  PotatoMall
//
//  Created by taotao on 12/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "CateGoryNModel.h"

@implementation CateGoryNModel

+ (NSMutableArray*)catesWithData:(id)data
{
    NSArray *list = [data objectForKey:@"list"];
    NSArray *array = [CateGoryNModel mj_objectArrayWithKeyValuesArray:list];
    return [NSMutableArray arrayWithArray:array];
}

@end
