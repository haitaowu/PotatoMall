//
//  CategoryCell.h
//  PotatoMall
//
//  Created by taotao on 07/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopScrollView.h"

@class ProdCateModel;

typedef void(^CategoryBlock)(ProdCateModel *obj);
@interface CategoryCell : UITableViewCell
@property (nonatomic,strong)NSMutableArray *categoryArray;
@property (nonatomic,copy) CategoryBlock cateBlock;

@end
