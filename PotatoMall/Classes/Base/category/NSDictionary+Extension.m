//
//  NSDictionary+Extension.m
//  doctor
//
//  Created by taotao on 2017/7/12.
//  Copyright © 2017年 孙彬彬. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)
- (NSString*)strValueForKey:(NSString*)key
{
    id valueStr = [self objectForKey:key];
    if ((valueStr == nil) || ([valueStr isKindOfClass:[NSNull class]])){
        return nil;
    }else{
        if ([valueStr isKindOfClass:[NSString class]]) {
            if ([valueStr containsString:@"null"]) {
                return nil;
            }else{
                return valueStr;
            }
        }else{
            return [NSString stringWithFormat:@"%@",valueStr];
        }
    }
}

        
- (NSNumber*)numberValueForKey:(NSString*)key
{
    NSNumber *valueNum = [self objectForKey:key];
    if ((valueNum == nil) || ([valueNum isKindOfClass:[NSNull class]])){
        return nil;
    }else{
        return valueNum;
    }
}

@end
