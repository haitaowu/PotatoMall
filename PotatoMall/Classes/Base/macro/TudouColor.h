//
//  TudouColor.h
//  PotatoMall
//
//  Created by taotao on 21/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

#define kMainTitleColor                     UIColorFromRGB(0x888888)
#define kMainBackgroundColor              RGBA(255, 68, 115, 1)
