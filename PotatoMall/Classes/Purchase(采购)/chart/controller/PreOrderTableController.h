//
//  PreOrderTableController.h
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

#define kByNow                  @"buyNow"
#define kByFormChart            @"kByFormChart"

@interface PreOrderTableController : BaseTableViewController
@property (nonatomic,strong)NSMutableArray *goodsArray;
@property (nonatomic,copy) NSString *buyType;
@end
