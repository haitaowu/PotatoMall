//
//  SeachSectionHeader.m
//  lepregt
//
//  Created by taotao on 28/02/2017.
//  Copyright © 2017 Singer. All rights reserved.
//

#import "SeachSectionHeader.h"


@interface SeachSectionHeader()
@property (nonatomic,weak)UILabel  *label;
@property (nonatomic,weak)UIButton  *trushView;
@end


@implementation SeachSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil){
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = self.bounds;
    self.label.x = 16;
    //setup trushView frame
    CGFloat wh = 30;
    CGFloat marginRight = 16;
    self.trushView.width = wh;
    self.trushView.height = wh;
    self.trushView.x = self.size.width - wh - marginRight;
    self.trushView.y = (self.size.height - wh) * 0.5;
}

#pragma mark - setup ui
- (void)setupUI
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"历史搜索";
    [self.contentView addSubview:label];
    label.textAlignment = NSTextAlignmentLeft;
    self.label = label;
    //trush imageView
    UIButton *trushView = [[UIButton alloc] init];
    UIImage *trushImg = [UIImage imageNamed:@"comm_trush"];
    [trushView setImage:trushImg forState:UIControlStateNormal];
    [trushView addTarget:self action:@selector(removeAllRecord) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:trushView];
    self.trushView = trushView;
}

#pragma mark - selectors
- (void)removeAllRecord
{
    if (self.deleteAllBlock != nil) {
        [[DataUtil shareInstance] deleteHomeSerachAllRecord];
        self.deleteAllBlock();
    }
}


@end
