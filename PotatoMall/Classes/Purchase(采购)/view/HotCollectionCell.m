//
//  HotCollectionCell.m
//  lepregt
//
//  Created by taotao on 6/8/16.
//  Copyright © 2016 Singer. All rights reserved.
//

#import "HotCollectionCell.h"
#import "GoodsModel.h"




@interface HotCollectionCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation HotCollectionCell

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
