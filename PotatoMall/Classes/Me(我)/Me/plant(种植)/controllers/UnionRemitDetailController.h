//
//  UnionRemitDetailController.h
//  PotatoMall
//
//  Created by taotao on 2017/10/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface UnionRemitDetailController : BaseTableViewController
@property (nonatomic,strong)NSString * unionId;
@property(nonatomic,strong) NSDictionary *orderInfo;
@end
