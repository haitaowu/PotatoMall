//
//  ChartCell.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "ChartCell.h"
#import "NSString+Extentsion.h"
#import "PlustField.h"

@interface ChartCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet PlustField *countField;
@property (weak, nonatomic) IBOutlet UIButton *deletBtn;
@property (weak, nonatomic) IBOutlet UILabel *adrLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation ChartCell
#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.countField.minusBlock = ^(NSString *countStr){
        [self updateCountLabelWithCount:countStr];
    };
    
    self.countField.plusBlock = ^(NSString *countStr){
        [self updateCountLabelWithCount:countStr];
    };
}

#pragma mark - update ui
- (void)updateCountLabelWithCount:(NSString *)countStr
{
    self.countField.text = countStr;
    self.model.num = countStr;
}

#pragma mark -  setter and getter methods 
- (void)setModel:(GoodsModel *)model
{
    _model = model;
    self.titleLabel.text = model.goodsInfoName;
    self.priceLabel.text = model.price;
    if (model.imageSrc != nil) {
        NSURL *picUrl = [NSURL URLWithString:model.imageSrc];
        UIImage *holderImg = [UIImage imageNamed:@"palcehodler_A"];
        [self.picView sd_setImageWithURL:picUrl placeholderImage:holderImg];
    }
    
    self.countField.text = model.num;
    self.selectView.selected = self.model.isSelected;
}

#pragma mark - selectors
- (IBAction)tapDeleteGiftBtn:(id)sender {
    if(self.deleteBlock != nil){
        self.deleteBlock(self.model);
    }
}

- (IBAction)tapSelectBtn:(UIButton*)sender {
    sender.selected = !sender.selected;
    self.model.isSelected = sender.selected;
}

@end
