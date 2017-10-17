//
//  NSDictionary+Extension.h
//  doctor
//
//  Created by taotao on 2017/7/12.
//  Copyright © 2017年 孙彬彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)
- (NSString*)strValueForKey:(NSString*)key;
- (NSNumber*)numberValueForKey:(NSString*)key;

@end
