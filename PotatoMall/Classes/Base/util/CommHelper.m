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
    if (str == nil) {
        str = @"";
    }
    HTLog(@"des = %@",str);
    CGSize size = CGSizeMake(MAXFLOAT,height);
    NSDictionary *attris = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize textSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attris context:nil].size;
    return  textSize.width ;
}


//字符高
+ (CGFloat)strHeightWithStr:(NSString*)str font:(UIFont*)font width:(CGFloat) width
{
    if (str == nil) {
        str = @"";
    }
    CGSize size = CGSizeMake(width,MAXFLOAT);
    NSDictionary *attris = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize textSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attris context:nil].size;
    return  textSize.height ;
}


#pragma mark - private methods
+ (NSRange)stringRangeWithStr:(NSString*)str keyword:(NSString*)keyword
{
    return [str rangeOfString:keyword];
}


+ (void)shareUrlWithScene:(int) scene title:(NSString*)title description:(NSString*)description imageUrl:(NSString*)imgUrl url:(NSString*)url
{
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    mediaMsg.title = title;
    mediaMsg.description = description;
    [CommHelper shareImageWithUrl:imgUrl finishedBlock:^(UIImage *img) {
        UIImage *scaleImg = [self scaleImageWithImg:img size:CGSizeMake(50,50)];
        [mediaMsg setThumbImage:scaleImg];
        WXWebpageObject *webPageObj = [WXWebpageObject object];
        webPageObj.webpageUrl = url;
        mediaMsg.mediaObject = webPageObj;
        
        SendMessageToWXReq *msgReq = [[SendMessageToWXReq alloc] init];
        msgReq.bText = NO;
        msgReq.message = mediaMsg;
        msgReq.scene = scene;
        [WXApi sendReq:msgReq];
    }];
}

#pragma mark - private methods
+ (void)shareImageWithUrl:(NSString*)imgUrl finishedBlock:(void(^)(UIImage *img))finishedBlock
{
    NSURL *url = [NSURL URLWithString:imgUrl];
    SDWebImageManager *imgManager = [SDWebImageManager sharedManager];
    [imgManager downloadImageWithURL:url options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (error == nil) {
            finishedBlock(image);
        }
    }];
}

+ (UIImage*)scaleImageWithImg:(UIImage*)img size:(CGSize)thumSize
{
    NSData *orginData = UIImagePNGRepresentation(img);
    UIImage *scaleImg = [img thumbImgWithSize:thumSize];
    NSData *scaleData = UIImagePNGRepresentation(scaleImg);
    HTLog(@"orginImage length = %ld scaleimage length = %ld",orginData.length,scaleData.length);
    return scaleImg;
}
@end
