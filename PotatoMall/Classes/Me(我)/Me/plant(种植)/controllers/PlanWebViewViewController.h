//
//  PlanWebViewViewController.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface PlanWebViewViewController : BaseViewController
@property (weak, nonatomic) IBOutlet NSString *murl;
@property (weak, nonatomic) IBOutlet UIWebView *mwebview;

@end
