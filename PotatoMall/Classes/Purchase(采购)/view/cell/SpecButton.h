//
//  SpecButton.h
//  PotatoMall
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>




#define kSpecName                  @"specName"
#define kGoodInfoId                @"goodInfoId"

@interface SpecButton : UIButton
@property (nonatomic,strong)NSDictionary *specDict;
@end
