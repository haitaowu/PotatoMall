//
//  NSDate+Extension.m
//  PotatoMall
//
//  Created by taotao on 2017/11/6.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSDate*)ymdDate
{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    formate.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formate stringFromDate:self];
    return [formate dateFromString:dateStr];
}
@end
