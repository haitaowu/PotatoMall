//
//  OrderCell.h
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"



@interface OrderCell : UITableViewCell
@property (nonatomic,copy) GoodsModel *model;
- (void)updateUIWithModel:(GoodsModel*) model totalCount:(NSInteger)count row:(NSInteger)row;
@end
