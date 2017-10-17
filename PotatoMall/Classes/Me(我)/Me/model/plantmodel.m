//
//  plantmodel.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/8.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "plantmodel.h"

@implementation plantmodel
+ (NSDictionary*)plantWithData:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    return [dict objectForKey:@"obj"];
}

+ (NSMutableArray*)plantWithDataArray:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSArray *obj = [dict objectForKey:@"obj"];
    
    NSLog(@"obj==%@",obj);
    return [self ordersWithArray:obj];
}

+ (NSMutableArray*)plantWithDataArray1:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSArray *obj = [[dict objectForKey:@"obj"]objectForKey:@"list"];
    
    return [self ordersWithArray:obj];
}

+ (NSMutableArray*)ordersWithArray:(id)data
{
    NSArray *orders = [plantmodel mj_objectArrayWithKeyValuesArray:data];
    return [NSMutableArray arrayWithArray:orders];
}

@end
