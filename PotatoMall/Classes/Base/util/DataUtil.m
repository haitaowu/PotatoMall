//
//  DataUtil.m
//  PotatoMall
//
//  Created by taotao on 27/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "DataUtil.h"
#import "SecurityUtil.h"

@implementation DataUtil

#pragma mark - public methods
+ (NSString*)decryptStringWith:(NSString*)crptStr
{
    NSString *decryptStr = [SecurityUtil decryptAES:crptStr];
    return decryptStr;
}

+ (NSDictionary*)dictionaryWithJsonStr:(id)jsonStr
{
    NSString *decryptStr = [self decryptStringWith:jsonStr];
    NSError *error = nil;
    NSData *data = [decryptStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return dict;
}

@end
