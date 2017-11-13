//
//  ReValidMemberController.h
//  PotatoMall
//
//  Created by taotao on 2017/10/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@class plantmodel;

@interface ReValidMemberController : BaseTableViewController
@property(nonatomic,strong) plantmodel *model;
@property(nonatomic,copy) NSString *unionId;
@end
