//
//  ArticleContentView.m
//  PotatoMall
//
//  Created by taotao on 16/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "ArticleContentView.h"
#import "SubTitleLabel.h"

#define kMargin         16


@interface ArticleContentView()<UIWebViewDelegate>
@property (weak, nonatomic)  UILabel *titleLabel;
@property (weak, nonatomic)  SubTitleLabel *authorLabel;
@property (weak, nonatomic)  UIWebView *webview;
@property (weak, nonatomic)  UIScrollView *contentView;
@property (weak, nonatomic)  SubTitleLabel *dateLabel;
@property (weak, nonatomic)  UIImageView *clockView;

@end

@implementation ArticleContentView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
       [self setupUI];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    //title label frame
    CGFloat titleX = kMargin;
    CGFloat titleY = kMargin;
    CGFloat titleW = kScreenWidth -  kMargin * 2;
    CGFloat titleH = [CommHelper strHeightWithStr:self.titleLabel.text font:self.titleLabel.font width:titleW];
    CGRect titleF = {{titleX,titleY},{titleW,titleH}};
    self.titleLabel.frame = titleF;
    
    CGFloat authorX = kMargin;
    CGFloat authorY = CGRectGetMaxY(titleF) + kMargin;
    [self.authorLabel sizeToFit];
    CGRect authorF = {{authorX,authorY},self.authorLabel.size};
    self.authorLabel.frame = authorF;
    
    [self.dateLabel sizeToFit];
    CGFloat delta = (self.authorLabel.height - self.dateLabel.height) * 0.5;
    CGFloat dateX = kScreenWidth - kMargin - self.dateLabel.width;
    CGFloat dateY = authorY + delta;
    CGRect dateF = {{dateX,dateY},self.dateLabel.size};
    self.dateLabel.frame = dateF;
    
    CGFloat clockWH = 15;
    CGFloat deltaY = (self.dateLabel.height - clockWH) * 0.5;
    CGFloat clockX = CGRectGetMinX(dateF) - clockWH - 5;
    CGFloat clockY = dateY + deltaY;
    CGRect clockF = {{clockX,clockY},{clockWH,clockWH}};
    self.clockView.frame = clockF;
    
    CGFloat webVX = 0;
    CGFloat webVY = CGRectGetMaxY(authorF) + kMargin;
    CGFloat webVW = kScreenWidth;
    CGFloat webVH = kScreenHeight - webVY;
    CGRect webF = {{webVX,webVY},{webVW,webVH}};
    self.webview.frame = webF;
    
    
}
#pragma mark - setup UI 
- (void)setupUI
{
    UIScrollView *contentV = [[UIScrollView alloc] init];
    self.contentView = contentV;
    [self addSubview:contentV];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    SubTitleLabel *authorLabel = [[SubTitleLabel alloc] init];
//    authorLabel.font = [UIFont systemFontOfSize:16];
    authorLabel.textColor = kBtnDisableStateColor;
    authorLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:authorLabel];
    self.authorLabel = authorLabel;
    
    SubTitleLabel *dateLabel = [[SubTitleLabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.textColor = kBtnDisableStateColor;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    UIImageView *clockView = [[UIImageView alloc] init];
    UIImage *clockImg = [UIImage imageNamed:@"home_clock"];
    clockView.image = clockImg;
    self.clockView = clockView;
    [self.contentView addSubview:clockView];
    
    UIWebView *webView = [[UIWebView alloc] init];
    [self.contentView addSubview:webView];
    self.webview = webView;
    self.webview.scrollView.scrollEnabled = NO;
//    [webView setScalesPageToFit:YES];
    webView.contentMode = UIViewContentModeScaleAspectFill;
    [webView setDelegate:self];
}

#pragma mark - private methods
- (void)calculatorWebScrollViewHeight
{
    CGFloat sHeight = self.webview.scrollView.contentSize.height;
    CGFloat webVY = CGRectGetMaxY(self.authorLabel.frame) + kMargin;
    CGFloat height = sHeight + webVY;
    CGSize size = CGSizeMake(kScreenWidth, height);
    self.contentView.contentSize = size;
    
    //webview frame
    CGFloat webVX = 0;
    CGFloat webVW = kScreenWidth;
    CGRect webF = {{webVX,webVY},{webVW,height}};
    self.webview.frame = webF;
    [SVProgressHUD dismiss];
}


#pragma mark -  setter and getter methods 
- (void)setDetail:(ArticleDetailModel *)detail
{
    _detail = detail;
    self.titleLabel.text = detail.title;
    self.authorLabel.text = detail.author;
    self.dateLabel.text = detail.createDate;
    [self.webview loadHTMLString:detail.content baseURL:nil];
    [self setNeedsLayout];
}

#pragma mark - UIWebViewDelegate 
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self calculatorWebScrollViewHeight];
    });
}
@end
