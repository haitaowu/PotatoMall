//
//  HTAlertView.h
//  HTAlertView
//
//  Created by 1 on 15/10/26.
//  Copyright © 2015年 HZQ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    SelectDone = 0,
    SelectCancel
    
}SelectType;

typedef void(^FriendsBlock)();
typedef void(^AllFriendsBlock)();



@interface HTAlertView : UIView
+ (HTAlertView*)showAleretViewWithFriendsBlock:(FriendsBlock)friendsBlock allFriendsBlock:(FriendsBlock)allBlock;
- (void)showView;



@end
