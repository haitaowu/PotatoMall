//
//  DataUtil.h
//  PotatoMall
//
//  Created by taotao on 27/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtil : NSObject
+ (NSString*)decryptStringWith:(NSString*)crptStr;
+ (NSDictionary*)dictionaryWithJsonStr:(id)jsonStr;
@end
