//
//  GoodsCell.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "GoodsCell.h"
#import "TitleLabel.h"
#import "NSString+Extentsion.h"

#define kSiderMargin                    16
#define kViewsVeritcalMarin             16
#define kImageHeightPercent             0.8

#define kImageWidthHPercent             230/167



@interface GoodsCell ()
@property (weak, nonatomic) IBOutlet TitleLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *adrLabel;
@end

@implementation GoodsCell
#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
    self.adrLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imgH = self.height * kImageHeightPercent;
    CGFloat imgW = imgH * kImageWidthHPercent;
    CGFloat imgX = kSiderMargin;
    CGFloat imgY = (self.height - imgH) * 0.5;
    CGRect imgF = {{imgX,imgY},{imgW,imgH}};
    self.picView.frame = imgF;
    
    [self.titleLabel sizeToFit];
    [self.adrLabel sizeToFit];
    [self.priceLabel sizeToFit];
    
    //title label
//    CGFloat delta = 8;
    CGFloat titleY = imgY;
    CGFloat titleX = CGRectGetMaxX(self.picView.frame) + kViewsVeritcalMarin;
    CGFloat titleW = self.width - titleX -  kSiderMargin;
    CGFloat titleHeight = [GoodsCell stringHeightWithStr:self.titleLabel.text font:self.titleLabel.font width:titleW];
    CGRect titleF = {{titleX,titleY},{titleW,titleHeight}};
    self.titleLabel.frame = titleF;
    
    CGFloat labelsHeight = titleHeight + self.priceLabel.height + self.adrLabel.height;
    CGFloat labelsMargin = (self.height - labelsHeight - imgY * 2) * 0.5;
    
    //adr label frame
    CGFloat adrX = titleX;
    CGFloat adrY = CGRectGetMaxY(self.titleLabel.frame) + labelsMargin;
    CGRect adrF = {{adrX,adrY},self.adrLabel.size};
    self.adrLabel.frame = adrF;
    
    //price label frame
    CGFloat priceX = titleX;
    CGFloat priceY = CGRectGetMaxY(self.adrLabel.frame) + labelsMargin;
    CGRect priceF = {{priceX,priceY},self.priceLabel.size};
    self.priceLabel.frame = priceF;
}


#pragma mark -  setter and getter methods 
- (void)setModel:(GoodsModel *)model
{
    _model = model;
    self.titleLabel.text = model.goodsInfoName;
    NSString *price = (model.price == nil) ? @"0":model.price;
    NSString *priceStr = [NSString stringWithFormat:@"￥%@",price];
    UIFont *hlFont = [UIFont systemFontOfSize:(self.priceLabel.font.pointSize + 5)];
    NSAttributedString *attriPriceStr = [CommHelper attriWithStr:priceStr keyword:price hlFont:hlFont];
    self.priceLabel.attributedText = attriPriceStr;
    
    self.adrLabel.text = model.goodsPlace;
    if (model.imageSrc != nil) {
        NSURL *picUrl = [NSURL URLWithString:model.imageSrc];
        UIImage *holderImg = [UIImage imageNamed:@"goods_placehodler"];
        [self.picView sd_setImageWithURL:picUrl placeholderImage:holderImg];
    }
}

#pragma mark - private methods
+ (CGFloat)stringHeightWithStr:(NSString*) str font:(UIFont*)font width:(CGFloat) width
{
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSDictionary *attris = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize textSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attris context:nil].size;
    return  textSize.height ;
}





#pragma mark - selectors

@end
