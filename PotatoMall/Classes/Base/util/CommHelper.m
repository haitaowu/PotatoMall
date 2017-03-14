//
//  CommHelper.m
//  PotatoMall
//
//  Created by taotao on 26/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "CommHelper.h"

@implementation CommHelper

#pragma mark - public methods
+ (NSAttributedString*)attriWithStr:(NSString*)str keyword:(NSString*)keyword hlFont:(UIFont*)font
{
    NSMutableAttributedString *attriStrName = [[NSMutableAttributedString alloc] initWithString:str];
    if (keyword == nil) {
        return attriStrName;
    }else{
        NSRange range = [self stringRangeWithStr:attriStrName.string keyword:keyword];
        NSDictionary *attris = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,font, NSFontAttributeName,nil];
        [attriStrName setAttributes:attris range:range];
        return attriStrName;
    }
}

//字符宽
+ (CGFloat)strWidthWithStr:(NSString*)str font:(UIFont*)font height:(CGFloat) height
{
    CGSize size = CGSizeMake(MAXFLOAT,height);
    NSDictionary *attris = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize textSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attris context:nil].size;
    return  textSize.width ;
}


#pragma mark - private methods
+ (NSRange)stringRangeWithStr:(NSString*)str keyword:(NSString*)keyword
{
    return [str rangeOfString:keyword];
}


@end
