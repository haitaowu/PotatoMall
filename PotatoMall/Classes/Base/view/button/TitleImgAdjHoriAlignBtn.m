//
//  TitleImgAdjHoriAlignBtn.m
//  lepregt
//
//  Created by taotao on 30/11/2016.
//  Copyright © 2016 Singer. All rights reserved.
//
/**
 *imageView 的高等于title的高，
 *imageView的高则根据图片自己的宽高比率 * title的高相乘计算
 *对齐方式是 文字-图片 右对齐
 */

#import "TitleImgAdjHoriAlignBtn.h"

#define kMarginDelta                  5
#define kImgHPer                      0.4



@implementation TitleImgAdjHoriAlignBtn

#pragma mark - override methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize viewSize = self.frame.size;
    [self.titleLabel sizeToFit];
    CGSize labelSize = self.titleLabel.frame.size;
    CGSize imgSize  = self.imageView.image.size;
    CGFloat imgWHRatio = imgSize.width / imgSize.height;
    CGFloat imageH = labelSize.height * kImgHPer;
    CGFloat imageW = imageH * imgWHRatio;
    
    //image  frame
    CGFloat imageVX = viewSize.width - imageW - kMarginDelta;
    CGFloat imageVY = (viewSize.height - imageH) * 0.5;
    CGRect imgvF = {{imageVX,imageVY},{imageW,imageH}};
    self.imageView.frame = imgvF;
    
    //label frame
    CGFloat labelX = CGRectGetMinX(imgvF) - kMarginDelta - labelSize.width;
    CGFloat labelY = (viewSize.height - labelSize.height) * 0.5;
    CGRect labelF = {{labelX,labelY},labelSize};
    self.titleLabel.frame = labelF;
    
   
    
   
}

@end
