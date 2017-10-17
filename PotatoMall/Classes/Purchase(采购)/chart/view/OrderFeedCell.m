//
//  OrderFeedCell.m
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderFeedCell.h"


@interface OrderFeedCell()
@end


@implementation OrderFeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)didMoveToSuperview
{
    [self setupUI];
}
#pragma mark - setup UI 
- (void)setupUI
{
    self.textView.placeholder = @"给商家留言";
}

@end
