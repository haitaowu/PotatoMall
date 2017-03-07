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
    NSArray *ads = [PurAdModel mj_objectArrayWithKeyValuesArray:data];
    return [NSMutableArray arrayWithArray:ads];
}

@end
