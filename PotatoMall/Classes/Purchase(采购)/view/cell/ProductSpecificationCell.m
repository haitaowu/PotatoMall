//
//  ProductSpecificationCell.m
//  PotatoMall
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "ProductSpecificationCell.h"

@interface ProductSpecificationCell()

@end

@implementation ProductSpecificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark -  setter and getter methods
- (void)setDetailModel:(GoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
}

@end
