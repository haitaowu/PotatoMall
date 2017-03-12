//
//  CateGoryNModel.h
//  PotatoMall
//
//  Created by taotao on 12/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CateGoryNModel : NSObject

/**名称*/
@property (nonatomic,copy) NSString *goodsInfoName;
/**...*/
@property (nonatomic,copy) NSString *imageSrc;
/**分类的ID*/
@property (nonatomic,copy) NSString *url;
/**分类的类型*/
@property (nonatomic,copy) NSString *type;
/**分类的sort*/
@property (nonatomic,copy) NSString *sort;

+ (NSMutableArray*)catesWithData:(id)data;

@end
