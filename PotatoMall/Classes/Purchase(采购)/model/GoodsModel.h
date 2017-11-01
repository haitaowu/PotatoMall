//
//  GoodsModel.h
//  PotatoMall
//
//  Created by taotao on 05/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>




//goodsId = 2618;
//goodsImg = "http://123.56.190.116:1000/upload/20170920/1505897415873.jpg";
//goodsName = "\U6d4b\U8bd5\U5546\U54c1\U63cf\U8ff0";
//goodsPlace = "\U5317\U4eac";
//goodsPrice = "1.00";



@interface GoodsModel : NSObject
/** 创建日期*/
@property (nonatomic,copy) NSString *createDate;
/** 货品ID*/
@property (nonatomic,copy) NSString *goodsId;
@property (nonatomic,copy) NSString *goodsInfoId;

/**价格*/
@property (nonatomic,copy) NSString *goodsPrice;
@property (nonatomic,copy) NSString *price;
/**图片地址*/
@property (nonatomic,copy) NSString *goodsImg;
@property (nonatomic,copy) NSString *imageSrc;
/**数量*/
@property (nonatomic,copy) NSString *num;
/**商品名称*/
@property (nonatomic,copy) NSString *goodsName;
@property (nonatomic,copy) NSString *goodsInfoName;

/**商品unit*/
@property (nonatomic,copy) NSString *unit;

/**商品地址*/
@property (nonatomic,copy) NSString *goodsPlace;

/**请求地址（暂无数据后期完善）*/
@property (nonatomic,copy) NSString *url;


/**类型（暂无数据后期完善）*/
@property (nonatomic,copy) NSString *type;

/**已经选择数量*/
@property (nonatomic,copy) NSString *selectedCount;

/**是否已经选择*/
@property (nonatomic,assign) Boolean isSelected;


- (NSString*)realGoodId;

+ (NSMutableArray*)goodsWithData:(id)data;

+ (NSMutableArray*)goodsWithArray:(id)data;

@end
