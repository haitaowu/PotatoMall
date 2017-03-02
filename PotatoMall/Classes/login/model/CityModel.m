//
//  CityModel.m
//  PotatoMall
//
//  Created by taotao on 02/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"id",@"cityId", nil];
}
@end
