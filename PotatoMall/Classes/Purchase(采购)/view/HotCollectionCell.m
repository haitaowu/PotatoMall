//
//  HotCollectionCell.m
//  lepregt
//
//  Created by taotao on 6/8/16.
//  Copyright © 2016 Singer. All rights reserved.
//

#import "HotCollectionCell.h"
#import "GoodsModel.h"

#define kImageTopMargin                 8
#define kViewsSideMargin                16
#define kImageViewHWRatio               175/240.0
#define kRadiusWH                       8



@interface HotCollectionCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak)UIImageView  *radiusView;
@end


@implementation HotCollectionCell
#pragma mark - override methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imgVX = kViewsSideMargin;
    CGFloat imgVY = kImageTopMargin;
    CGFloat imgW = self.contentView.width - imgVX * 2;
    CGFloat imgH = imgW * kImageViewHWRatio;
    CGRect imgVF = {{imgVX,imgVY},{imgW,imgH}};
    self.imageView.frame = imgVF;
    //label frame
    CGFloat labelY = CGRectGetMaxY(imgVF);
    CGFloat labelH = self.contentView.height - imgH;
    CGFloat labelStrW = [CommHelper strWidthWithStr:self.titleLabel.text font:self.titleLabel.font height:labelH];
    CGFloat labelLimitW = self.contentView.width - kRadiusWH;
    CGFloat labelW = 0;
    //radius
    CGFloat radiusX = 0;
    if (labelStrW > labelLimitW) {
        radiusX = kViewsSideMargin;
        labelW = labelLimitW;
    }else{
        labelW = labelStrW;
        radiusX = (self.contentView.width - kRadiusWH - labelStrW) * 0.5;
    }
    CGFloat labelX = radiusX + kRadiusWH;
    CGRect labelF = {{labelX,labelY},{labelW,labelH}};
    self.titleLabel.frame = labelF;
    
    //radius image view frame
    
    CGFloat radiusY = labelY + (labelH - kRadiusWH) * 0.5;
    CGRect radiusF = {{radiusX,radiusY},{kRadiusWH,kRadiusWH}};
    self.radiusView.frame = radiusF;
}

#pragma mark - setup UI 
- (void)setupUI
{
    UIImageView *radiusView = [[UIImageView alloc] init];
    [self.contentView addSubview:radiusView];
    self.radiusView = radiusView;
    radiusView.layer.cornerRadius = 4;
    radiusView.layer.masksToBounds = YES;
    self.radiusView.image = [UIImage imageWithColor:[UIColor redColor]];
}

- (void)updateUIWithModel:(GoodsModel*)model itemIdx:(NSInteger)index
{
    [self setModel:model];
    UIColor *radiusColor = [UIColor redColor];
    int idx = index % 3;
    if (idx == 0) {
        radiusColor = RGBA(95, 218, 162, 1);
    }else if (idx == 1) {
        radiusColor = RGBA(253, 94, 99, 1);
    }else{
        radiusColor = RGBA(91, 63, 215, 1);
    }
    self.radiusView.image = [UIImage imageWithColor:radiusColor];
}
#pragma mark -  setter and getter methods
- (void)setModel:(GoodsModel *)model
{
    _model = model;
    if (model.imageSrc != nil) {
        NSURL *picUrl = [NSURL URLWithString:model.imageSrc];
        UIImage *holderImg = [UIImage imageNamed:@"goods_placehodler"];
        [self.imageView sd_setImageWithURL:picUrl placeholderImage:holderImg];
    }
    self.titleLabel.text = model.goodsInfoName;
}


@end
