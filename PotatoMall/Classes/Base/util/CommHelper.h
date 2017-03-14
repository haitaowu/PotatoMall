//
//  CommHelper.h
//  PotatoMall
//
//  Created by taotao on 26/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommHelper : NSObject

/**根据给定的关键字显示红色*/
+ (NSAttributedString*)attriWithStr:(NSString*)str keyword:(NSString*)keyword hlFont:(UIFont*)font;
/**根据高度、字体来计算字符的宽度*/
+ (CGFloat)strWidthWithStr:(NSString*)str font:(UIFont*)font height:(CGFloat) height;
//分享url到朋友圈/朋友
+ (void)shareUrlWithScene:(int) scene title:(NSString*)title description:(NSString*)description image:(UIImage*)img url:(NSString*)url;
@end
