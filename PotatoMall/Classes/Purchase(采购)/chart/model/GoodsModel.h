//
//  GoodsModel.h
//  PotatoMall
//
//  Created by taotao on 05/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject
/** 创建日期*/
@property (nonatomic,copy) NSString *createDate;
/** 货品ID*/
@property (nonatomic,copy) NSString *goodsInfoId;
/**价格*/
@property (nonatomic,copy) NSString *price;
/**图片地址*/
@property (nonatomic,copy) NSString *imageSrc;
/**数量*/
@property (nonatomic,copy) NSString *num;
/**商品名称*/
@property (nonatomic,copy) NSString *goodsInfoName;

/**商品unit*/
@property (nonatomic,copy) NSString *unit;

/**请求地址（暂无数据后期完善）*/
@property (nonatomic,copy) NSString *url;
/**类型（暂无数据后期完善）*/
@property (nonatomic,copy) NSString *type;

/**已经选择数量*/
@property (nonatomic,copy) NSString *selectedCount;

/**是否已经选择*/
@property (nonatomic,assign) Boolean isSelected;

+ (NSMutableArray*)goodsWithData:(id)data;

+ (NSMutableArray*)goodsWithArray:(id)data;

@end
