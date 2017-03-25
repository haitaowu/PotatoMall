//
//  HTAlertView.m
//  HTAlertView
//
//  Created by 1 on 15/10/26.
//  Copyright © 2015年 HZQ. All rights reserved.
//

#import "HTAlertView.h"

//屏幕的宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕的高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HTAlertView ()
@property (nonatomic,copy)FriendsBlock  friendsBlock;
@property (nonatomic,copy)FriendsBlock  allBlock;
@end

static HTAlertView *instance = nil;

@implementation HTAlertView

+ (HTAlertView*)showAleretViewWithFriendsBlock:(FriendsBlock)friendsBlock allFriendsBlock:(FriendsBlock)allBlock
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HTAlertView" owner:nil options:nil];
    HTAlertView *alertView = (HTAlertView*)[nibView objectAtIndex:0];
    alertView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    alertView.allBlock = allBlock;
    alertView.friendsBlock = friendsBlock;
    return alertView;
}



// 
- (IBAction)tapBackGroundView:(id)sender {
    [self disappearView];
}

- (IBAction)tapShareToFriendsBtn:(id)sender {
    [self disappearView];
    if (self.friendsBlock != nil) {
        self.friendsBlock();
    }
}

- (IBAction)tapShareToAllFriendsBtn:(id)sender {
    [self disappearView];
    if (self.allBlock != nil) {
        self.allBlock();
    }
}

// 取消
- (IBAction)tapCancelBtn:(id)sender {
    [self disappearView];
}


- (void)disappearView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showView
{
    UIView *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.alpha = 0.0;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}


#pragma mark - private methods


@end


