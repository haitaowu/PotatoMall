//
//  MeMenuCollectionViewCell.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/8/31.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MeMenuCollectionViewCell.h"

@implementation MeMenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"MeMenuCollectionViewCell" owner:self options:nil].lastObject;
    }
    
    return self;
}

@end
