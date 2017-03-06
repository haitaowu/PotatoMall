//
//  ProductDetailTableController.h
//  PotatoMall
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "GoodsModel.h"


@interface ProductDetailTableController : BaseTableViewController
@property (nonatomic,strong) GoodsModel *goodModel;


@end
