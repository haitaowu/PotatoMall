//
//  ProdCateModel.h
//  PotatoMall
//
//  Created by taotao on 07/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProdCateModel : NSObject
/** 主键*/
@property (nonatomic,strong) NSNumber *cateId;
/**名称*/
@property (nonatomic,copy) NSString *name;
/**父级ID*/
@property (nonatomic,strong) NSNumber *parentId;


+ (NSMutableArray*)productCategoryesWithData:(id)data;

@end
