//
//  CommHelper.m
//  PotatoMall
//
//  Created by taotao on 26/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "CommHelper.h"
#import "WXApi.h"

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


+ (void)shareUrlWithScene:(int) scene title:(NSString*)title description:(NSString*)description image:(UIImage*)img url:(NSString*)url
{
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    mediaMsg.title = title;
    mediaMsg.description = description;
    [mediaMsg setThumbImage:img];
    
    WXWebpageObject *webPageObj = [WXWebpageObject object];
    webPageObj.webpageUrl = url;
    mediaMsg.mediaObject = webPageObj;
    
    SendMessageToWXReq *msgReq = [[SendMessageToWXReq alloc] init];
    msgReq.bText = NO;
    msgReq.message = mediaMsg;
    msgReq.scene = scene;
    [WXApi sendReq:msgReq];
}

@end
