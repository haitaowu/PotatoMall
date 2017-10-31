//
//  GoodsCell.h
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

typedef void(^ProductTapBlock) (GoodsModel *goods);


@interface GoodsCell : UITableViewCell
@property (nonatomic,copy) GoodsModel *model;
@property(nonatomic,copy) ProductTapBlock prouctBlock;
@end
