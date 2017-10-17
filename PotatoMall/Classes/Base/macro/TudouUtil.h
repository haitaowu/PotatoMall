//
//  TudouUtil.h
//  PotatoMall
//
//  Created by taotao on 22/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//


#ifdef DEBUG
#define HTLog(format, ...) printf("\n[第%d行] %s\n", __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define HTLog(format, ...)
#endif

#define kScreenWidth                        CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight                       CGRectGetHeight([UIScreen mainScreen].bounds)
