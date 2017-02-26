//
//  NSString+Extentsion.h
//  lepregt
//
//  Created by taotao on 8/22/16.
//  Copyright © 2016 Singer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extentsion)
- (NSString*)ymdFromDetailDate;
- (BOOL)validateIDCard;
- (BOOL)isBeforeThisYear;
- (BOOL)rightPhoneNumFormat;
@end
