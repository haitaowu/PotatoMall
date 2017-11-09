//
//  JoinedPlanedOptionController.h
//  PotatoMall
//
//  Created by taotao on 2017/11/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "BaseViewController.h"

@interface JoinedPlanedOptionController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSString *planState;
@property(nonatomic,copy) NSString *unionId;

@end
