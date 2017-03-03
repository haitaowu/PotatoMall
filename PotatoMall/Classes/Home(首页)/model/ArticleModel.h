//
//  ArticleModel.h
//  PotatoMall
//
//  Created by taotao on 27/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModel : NSObject

/** 创建日期*/
@property (nonatomic,copy) NSString *createDate;
/**描述*/
@property (nonatomic,copy) NSString *descrpt;
/**图片地址*/
@property (nonatomic,copy) NSString *imgSrc;
/**主键*/
@property (nonatomic,copy) NSString *infoId;
/**标题*/
@property (nonatomic,copy) NSString *title;


+ (NSMutableArray*)articlesWithData:(id)data;
@end
