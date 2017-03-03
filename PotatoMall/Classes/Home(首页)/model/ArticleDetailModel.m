//
//  ArticleDetailModel.m
//  PotatoMall
//
//  Created by taotao on 27/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "ArticleDetailModel.h"

@implementation ArticleDetailModel

+ (ArticleDetailModel*)articleDetailWithData:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSDictionary *obj = [dict objectForKey:@"obj"];
    ArticleDetailModel *articleDetailModel = [ArticleDetailModel mj_objectWithKeyValues:obj];
    return articleDetailModel;
}

@end
