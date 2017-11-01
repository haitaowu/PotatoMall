//
//  OrderDetailCell.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderDetailCell.h"
#import "NSString+Extentsion.h"

@interface OrderDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation OrderDetailCell
#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
}


#pragma mark -  setter and getter methods 
- (void)setModel:(GoodsModel *)model
{
    _model = model;
    self.titleLabel.text = model.goodsName;
    self.priceLabel.text = model.goodsPrice;
    if (model.goodsImg != nil) {
        NSURL *picUrl = [NSURL URLWithString:model.goodsImg];
        UIImage *holderImg = [UIImage imageNamed:@"palcehodler_A"];
        [self.picView sd_setImageWithURL:picUrl placeholderImage:holderImg];
    }
    
}

#pragma mark - selectors

@end
