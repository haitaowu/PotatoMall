//
//  OrderCell.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderCell.h"
#import "NSString+Extentsion.h"

@interface OrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation OrderCell
#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
}


#pragma mark -  setter and getter methods 
- (void)setModel:(OrderGoodsModel *)model
{
    _model = model;
    self.titleLabel.text = model.goodsInfoName;
    NSString *priceStr = [NSString stringWithFormat:@"￥%@/公斤",model.price];
    UIFont *hlFont = [UIFont systemFontOfSize:(self.priceLabel.font.pointSize + 5)];
    NSAttributedString *attriPriceStr = [CommHelper attriWithStr:priceStr keyword:model.price hlFont:hlFont];
    self.priceLabel.attributedText = attriPriceStr;
    
    //number label
    self.numLabel.text = model.num;
    
//    self.priceLabel.text = model.price;
    if (model.imageSrc != nil) {
        NSURL *picUrl = [NSURL URLWithString:model.imageSrc];
        UIImage *holderImg = [UIImage imageNamed:@"goods_placehodler"];
        [self.picView sd_setImageWithURL:picUrl placeholderImage:holderImg];
    }

}

#pragma mark - selectors


@end
