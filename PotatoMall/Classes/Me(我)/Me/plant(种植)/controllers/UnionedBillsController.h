//
//  UnionedBillsController.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface UnionedBillsController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
    
@property (nonatomic,strong)NSString * unionId;

@end
