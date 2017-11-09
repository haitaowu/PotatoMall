//
//  UIViewController+NavigationBar.h
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBar)
- (void)setNavigationBarMainStyle;
- (void)showLoginView;
/**
 *pop current viewController after seconds delay
 */
- (void)popCurrentViewControllerAfterDelay;
@end
