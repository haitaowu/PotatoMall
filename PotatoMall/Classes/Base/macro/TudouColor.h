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

#define kMainTitleColor                         UIColorFromRGB(0x888888)

#define kMainBackgroundColor                    RGBA(255, 68, 115, 1)

#define kMainNavigationBarColor                 RGBA(253, 187, 63, 1)

//tabbar color 
#define kMainTabBarSelectedTitleColor           kMainNavigationBarColor
#define kMainTabBarNormalTitleColor             RGBA(184, 184, 194, 1)

#define kSearchBarBGColor                       RGBA(237 ,175	,63, 1)

#define kHistorySearchBarBGColor                RGBA(239 ,239,239, 1)
#define kHistorySearchBarTitleColor             RGBA(88 ,88	,88, 1)

