//
//  ChartCell.h
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

typedef void(^DeleteBlock)(GoodsModel *model);
typedef void(^ChoiceCountBlock)(GoodsModel *model);

@interface ChartCell : UITableViewCell
@property (nonatomic,copy) GoodsModel *model;
@property (nonatomic,copy) DeleteBlock deleteBlock;
@property (nonatomic,copy) ChoiceCountBlock countBlock;
- (void)updateNODeleteWithModel:(GoodsModel*)model;
@end
