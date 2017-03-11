//
//  PurAdModel.m
//  PotatoMall
//
//  Created by taotao on 07/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "PurAdModel.h"

@implementation PurAdModel

+ (NSMutableArray*)adsWithData:(id)data
{
    NSArray *list = data[@"list"];
    NSArray *ads = [PurAdModel mj_objectArrayWithKeyValuesArray:list];
    return [NSMutableArray arrayWithArray:ads];
}

@end
