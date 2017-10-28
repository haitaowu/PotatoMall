//
//  VertiImgTitleBtn.m
//  lepregt
//
//  Created by taotao on 30/11/2016.
//  Copyright © 2016 Singer. All rights reserved.
//

#import "VertiImgTitleBtn.h"

#define kDelta                                    3
#define kImageHeightPercent                       0.3



@implementation VertiImgTitleBtn

#pragma mark - override methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize viewSize = self.frame.size;
    CGSize imgSize = self.imageView.image.size;
    CGFloat ratioWH = imgSize.width /imgSize.height;
    CGFloat imgH = viewSize.height * kImageHeightPercent;
    CGFloat imgW = imgH * ratioWH;
    [self.titleLabel sizeToFit];
    CGSize labelSize = self.titleLabel.frame.size;
    //image  frame
    CGFloat imageVX = (viewSize.width - imgW) * 0.5;
    CGFloat imageVY = (viewSize.height - imgH - labelSize.height - kDelta) * 0.5;
    CGRect imgvF = {{imageVX,imageVY},{imgW,imgH}};
    self.imageView.frame = imgvF;
    
    //label frame
    CGFloat labelX = (viewSize.width - labelSize.width) * 0.5;
    CGFloat labelY = CGRectGetMaxY(imgvF) + kDelta;
    CGRect labelF = {{labelX,labelY},labelSize};
    self.titleLabel.frame = labelF;
}

@end
