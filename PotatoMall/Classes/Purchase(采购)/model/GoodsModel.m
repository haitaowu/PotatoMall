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
- (NSString*)goodsPrice
{
    if (_goodsPrice == nil) {
        return _price;
    }else{
        return _goodsPrice;
    }
}

- (NSString*)goodsImg
{
    if (_goodsImg == nil) {
        return _imageSrc;
    }else{
        return _goodsImg;
    }
}

- (NSString*)goodsName
{
    if (_goodsName == nil) {
        return _goodsInfoName;
    }else{
        return _goodsName;
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
