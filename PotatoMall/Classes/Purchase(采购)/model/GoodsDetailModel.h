//
//  GoodsDetailModel.h
//  PotatoMall
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetailModel : NSObject
/** 扩展属性*/
@property (nonatomic,copy) NSArray *goodsExpandparams;
/** 参数*/
@property (nonatomic,copy) NSArray *goodsParams;
/** 规格*/
@property (nonatomic,copy) NSArray *goodsSpecs;
/**商品ID*/
@property (nonatomic,copy) NSString *goodsId;
/**商品名称*/
@property (nonatomic,copy) NSString *goodsInfoName;
/**货品ID*/
@property (nonatomic,copy) NSString *goodsInfoId;
/**价格*/
@property (nonatomic,copy) NSString *price;
/**图片地址*/
@property (nonatomic,copy) NSString *imageSrc;
/**介绍所有图片地址*/
@property (nonatomic,copy) NSArray *images;
/**描述*/
@property (nonatomic,copy) NSString *moblieDesc;
/**状态*/
@property (nonatomic,copy) NSString *status;


+ (GoodsDetailModel*)goodsDetailWithData:(id)data;
@end
