//
//  ArticleModel.m
//  PotatoMall
//
//  Created by taotao on 27/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"description",@"descrpt", nil];
}


+ (NSMutableArray*)articlesWithData:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSArray *list = [dict objectForKey:@"list"];
    NSArray *articles = [ArticleModel mj_objectArrayWithKeyValuesArray:list];
    return [NSMutableArray arrayWithArray:articles];
}

@end
