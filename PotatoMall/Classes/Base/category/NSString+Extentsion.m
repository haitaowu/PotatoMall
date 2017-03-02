//
//  NSString+Extentsion.m
//  lepregt
//
//  Created by taotao on 8/22/16.
//  Copyright © 2016 Singer. All rights reserved.
//

#import "NSString+Extentsion.h"

@implementation NSString (Extentsion)

#pragma mark - public methods
- (NSString*)strWithoutSpace
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
}
- (NSString*)ymdFromDetailDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *dateDetail = [dateFormat dateFromString:self];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    NSString *formatDate = [dateFormat stringFromDate:dateDetail];
    return formatDate;
}


- (BOOL)validateIDCard
{
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

// yyyyMMdd
- (BOOL)isBeforeThisYear
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyyMMdd";
    NSDate *date = [dateFormat dateFromString:self];
    if (date == nil) {
        return NO;
    }else{
        if ([self beforeThisYear:date]) {
            return YES;
        }else{
            return NO;
        }
    }
}

- (BOOL)beforeThisYear:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date toDate:today options:0];
    if (comps.year <= 0) {
        return NO;
    }else{
        return YES;
    }
}


//validate phone number format
- (BOOL)rightPhoneNumFormat
{
    NSString *regex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [phonePredicate evaluateWithObject:self];
}



@end
