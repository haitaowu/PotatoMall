//
//  PregnantLessionHeader.m
//  lepregt
//
//  Created by taotao on 6/25/16.
//  Copyright © 2016 Singer. All rights reserved.
//

#import "SectionHeaderTitle.h"


#define kTtitleViewW                200
#define kLeftMargin                 8
#define kImageHeightPercent         0.8


@interface SectionHeaderTitle()
@property (nonatomic,weak)UILabel  *titleView;
@property (nonatomic,weak)UIImageView  *imgView;
@property (nonatomic,weak)UIView   *backgroundView;
@property (nonatomic,weak)UIView   *separtorLine;
@property (nonatomic,assign) LineType lineType;


@end

@implementation SectionHeaderTitle

#pragma mark - override methods
- (instancetype)initWithTitle:(NSString*)title
{
    self = [super init];
    if (self != nil) {
        [self setupUIWithTitle:title];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize viewSize = self.frame.size;
    [self.titleView sizeToFit];
    CGSize titleSize = self.titleView.size;
    
    //imageView frame
    CGFloat imgVX = kLeftMargin;
    CGFloat imgH =  titleSize.height * kImageHeightPercent;
    CGFloat imgVY = (viewSize.height  - imgH) * 0.5;
    CGRect imgVF = {{imgVX,imgVY},{imgH * 0.25,imgH}};
    self.imgView.frame = imgVF;
    
    //titleView frame
    CGFloat leftMargin = 5;
    CGFloat titleX = leftMargin + CGRectGetMaxX(imgVF);
    CGFloat titleY = (viewSize.height - titleSize.height) * 0.5;
    CGRect titleFrame = {{titleX,titleY},titleSize};
    self.titleView.frame = titleFrame;
    
    //backgroundview frame
    self.backgroundView.frame = self.bounds;
    
   
    
    //separator frame
//    CGFloat sepY;
//    if (self.lineType == DefaultLineType) {
//        sepY = deltaY;
//    }else if (self.lineType == BottomLineType) {
//        sepY = viewSize.height - 0.5;
//    }
//    CGRect sepFrame = {{0,sepY},{self.frame.size.width,0.5}};
//    self.separtorLine.frame = sepFrame;
}


#pragma mark - private setup ui
- (void)setupUIWithTitle:(NSString*)title
{
    UIView *bgView = [[UIView alloc] init];
    self.backgroundView = bgView;
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    
    // titleView label
    UILabel *titleView = [[UILabel alloc] init];
    self.titleView = titleView;
    [self addSubview:titleView];
    [titleView setTextColor:kHotArticleitleColor];
    titleView.text = title;
   
    //UIImageView init
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *img = [UIImage imageNamed:@"verticalline"];
    imageView.image = img;
    self.imgView = imageView;
    [self addSubview:imageView];
    
    //separator line 
//    UIView *separtorLine = [[UIView alloc] init];
//    self.separtorLine = separtorLine;
//    [self addSubview:separtorLine];
}

#pragma mark - private methods
//-(UIFont*)titleLabelFont
//{
//    if(iOS40 == YES){
//        return [UIFont boldSystemFontOfSize:14];
//    }else if(iOS47 == YES){
//        return [UIFont boldSystemFontOfSize:16];
//    }else if(iOS55 == YES){
//        return [UIFont boldSystemFontOfSize:18];
//        //#warning 临时调整 字体大小
//    }else{
//        return [UIFont boldSystemFontOfSize:14];
//    }
//}

@end
