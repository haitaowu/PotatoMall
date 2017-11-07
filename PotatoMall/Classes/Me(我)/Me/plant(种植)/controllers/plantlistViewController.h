//
//  plantlistViewController.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TopScrollView.h"
@interface plantlistViewController : BaseViewController
@property (weak, nonatomic) IBOutlet TopScrollView *topview;
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property(nonatomic,copy) NSString *unionId;

@end
