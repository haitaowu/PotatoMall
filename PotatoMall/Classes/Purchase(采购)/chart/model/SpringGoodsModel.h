//
//  SpringGoodsModel.h
//  PotatoMall
//
//  Created by taotao on 11/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpringGoodsModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSMutableArray *list;

+ (SpringGoodsModel*)goodsWithData:(id)data;

@end
