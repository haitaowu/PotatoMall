//
//  PlantRecordCell.m
//  PotatoMall
//
//  Created by taotao on 2017/11/5.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlantRecordCell.h"
#import "plantmodel.h"


@interface PlantRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation PlantRecordCell

#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - public methods
- (void)updateUIWithOutImg:(plantmodel*)model
{
    _model = model;
    self.imgView.hidden = YES;
    self.contentLabel.text = model.content;
}
#pragma mark - setter mothods
- (void)setModel:(plantmodel *)model
{
    _model = model;
    self.imgView.hidden = NO;
    self.contentLabel.text = model.content;
    NSURL *url = [NSURL URLWithString:model.imagesUrls];
    UIImage *holderPlace = [UIImage imageNamed:@"goods_placehodler"];
    [self.imgView sd_setImageWithURL:url placeholderImage:holderPlace];
}






@end
