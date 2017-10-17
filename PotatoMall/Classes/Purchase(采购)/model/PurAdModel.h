//
//  PurAdModel.h
//  PotatoMall
//
//  Created by taotao on 07/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurAdModel : NSObject
/**货品ID*/
@property (nonatomic,copy) NSString *goodsInfoId;
/**商品名称*/
@property (nonatomic,copy) NSString *goodsInfoName;
/**图片地址*/
@property (nonatomic,copy) NSString *imageSrc;
/**价格*/
@property (nonatomic,copy) NSString *price;
/**单位*/
@property (nonatomic,copy) NSString *unit;

+ (NSMutableArray*)adsWithData:(id)data;

@end
