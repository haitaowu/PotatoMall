//
//  ArticleDetailModel.h
//  PotatoMall
//
//  Created by taotao on 27/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleDetailModel : NSObject

/** 创建日期*/
@property (nonatomic,copy) NSString *createDate;
/**文章内容*/
@property (nonatomic,copy) NSString *content;
/**文章内容*/
@property (nonatomic,copy) NSString *author;
/**主键*/
@property (nonatomic,copy) NSString *infoId;
/**标题*/
@property (nonatomic,copy) NSString *title;

+ (ArticleDetailModel*)articleDetailWithData:(id)data;
@end
