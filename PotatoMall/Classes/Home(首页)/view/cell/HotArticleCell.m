//
//  HotArticleCell.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HotArticleCell.h"
@interface HotArticleCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@end
@implementation HotArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark -  setter and getter methods 
- (void)setModel:(ArticleModel *)model
{
    _model = model;
    self.titleLabel.text = model.title;
    self.dateLabel.text = model.createDate;
    if (model.imgSrc != nil) {
        NSURL *picUrl = [NSURL URLWithString:model.imgSrc];
        UIImage *holderImg = [UIImage imageNamed:@"palcehodler_A"];
        [self.picView sd_setImageWithURL:picUrl placeholderImage:holderImg];
    }
}


@end
