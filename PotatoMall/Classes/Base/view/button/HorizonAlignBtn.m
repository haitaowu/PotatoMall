//
//  HorizonAlignBtn.m
//  lepregt
//
//  Created by taotao on 30/11/2016.
//  Copyright © 2016 Singer. All rights reserved.
//

#import "HorizonAlignBtn.h"

#define kDelta                                    3
//#define kImageHeightPercent                       0.5



@implementation HorizonAlignBtn

#pragma mark - override methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        [self setTitleColor:kBtnDisableStateColor forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize viewSize = self.frame.size;
    [self.titleLabel sizeToFit];
    CGSize labelSize = self.titleLabel.frame.size;
    CGFloat imageHW = 10;
    //image  frame
    CGFloat imageVX = viewSize.width - imageHW;
    CGFloat imageVY = (viewSize.height - imageHW) * 0.5;
    CGRect imgvF = {{imageVX,imageVY},{imageHW,imageHW}};
    self.imageView.frame = imgvF;
    
    //label frame
    CGFloat labelX = CGRectGetMinX(imgvF) - kDelta - labelSize.width;
    CGFloat labelY = (viewSize.height - labelSize.height) * 0.5;
    CGRect labelF = {{labelX,labelY},labelSize};
    self.titleLabel.frame = labelF;
}

@end
