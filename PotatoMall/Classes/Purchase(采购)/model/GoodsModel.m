//
//  GoodsModel.m
//  PotatoMall
//
//  Created by taotao on 05/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel
#pragma mark - public methods
- (NSString*)realGoodId
{
    if (self.goodsId == nil) {
        return self.goodsInfoId;
    }else{
        return self.goodsId;
    }
}

+ (NSMutableArray*)goodsWithData:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSArray *list = [dict objectForKey:@"obj"];
    return [self goodsWithArray:list];
}

+ (NSMutableArray*)goodsWithArray:(id)data
{
    NSArray *goods = [GoodsModel mj_objectArrayWithKeyValuesArray:data];
    return [NSMutableArray arrayWithArray:goods];
}

-(NSString*)selectedCount
{
    if (_selectedCount == nil) {
        _selectedCount = @"1";
    }
    return _selectedCount;
}

@end
