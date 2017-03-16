//
//  ParamsCell.h
//  PotatoMall
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

typedef enum : NSUInteger {
    ParamsTypeImage,
    ParamsTypeLabels
}  ParamsType;

typedef void(^CellHeightBlock)(ParamsType type,CGFloat height);
@interface ParamsCell : UITableViewCell
@property (nonatomic,strong)GoodsDetailModel *detailModel;
@property (nonatomic,copy) CellHeightBlock heightBlock;

@end
