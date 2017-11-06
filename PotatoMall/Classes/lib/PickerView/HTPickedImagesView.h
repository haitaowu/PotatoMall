//
//  HTPickedImagesView.h
//  RoseDecoration
//
//  Created by taotao on 2017/10/10.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^ImgsCountChangedBlock)(NSArray *imgs,CGFloat height);

@interface HTPickedImagesView : UIView
@property(nonatomic,copy) ImgsCountChangedBlock imgChangeBlock;
@property(nonatomic,strong) UIViewController* currentController;
/**
 *item的高度。
 */
- (CGFloat)itemsWHeight;

@end
