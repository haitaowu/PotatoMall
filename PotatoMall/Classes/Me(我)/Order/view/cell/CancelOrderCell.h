//
//  CancelOrderCell.h
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

typedef void(^CancelBlock)();

@interface CancelOrderCell : UITableViewCell
@property (nonatomic,copy) GoodsModel *model;
@property (nonatomic,copy)CancelBlock  cancelBlock;
@end
