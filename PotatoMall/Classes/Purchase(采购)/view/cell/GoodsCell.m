//
//  GoodsCell.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "GoodsCell.h"
#import "NSString+Extentsion.h"

#define kImgTopMargin          10
#define kImgLeftMarin          16
#define kViewsMarin            16
#define kLabelTopMarin         18



@interface GoodsCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *adrLabel;
@end

@implementation GoodsCell
#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
     HTLog(@"awakeFromNib awakeFromNib");
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    HTLog(@"layout subviews");
    HTLog(@"titleLabel frame = %@",NSStringFromCGRect(self.titleLabel.frame));
    CGFloat titleLabelMaxY = CGRectGetMaxY(self.titleLabel.frame);
    CGFloat priceLabelMinY = CGRectGetMinY(self.priceLabel.frame);
    CGFloat gap = priceLabelMinY - titleLabelMaxY;
    [self.adrLabel sizeToFit];
    CGSize adrSize = self.adrLabel.size;
    CGFloat delta = (gap - adrSize.height) / 2;
    CGFloat adrX = self.titleLabel.x;
    CGFloat adrY = titleLabelMaxY + delta;
    CGRect adrF = {{adrX,adrY},adrSize};
    self.adrLabel.frame = adrF;
}

#pragma mark -  setter and getter methods 
- (void)setModel:(GoodsModel *)model
{
    _model = model;
    HTLog(@"setModel methods ..... ");
    self.titleLabel.text = model.goodsInfoName;
    self.priceLabel.text = model.price;
    if (model.imageSrc != nil) {
        NSURL *picUrl = [NSURL URLWithString:model.imageSrc];
        UIImage *holderImg = [UIImage imageNamed:@"palcehodler_A"];
        [self.picView sd_setImageWithURL:picUrl placeholderImage:holderImg];
    }
}

#pragma mark - selectors

@end
