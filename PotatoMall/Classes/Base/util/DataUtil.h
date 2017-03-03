//
//  DataUtil.h
//  PotatoMall
//
//  Created by taotao on 27/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTableName                      @"HomeSearch"
#define kColID                          @"ID"
#define kColTitle                       @"title"


@interface DataUtil : NSObject
+(instancetype)shareInstance;
+ (NSString*)decryptStringWith:(NSString*)crptStr;
+ (id)dictionaryWithJsonStr:(id)jsonStr;

- (void)saveHomeSerachRecordWithTitle:(NSString*)title;
- (NSArray*)queryHomeSerachRecord;
- (BOOL)deleteHomeSerachRecord:(NSDictionary*)record;
- (BOOL)deleteHomeSerachAllRecord;

@end
