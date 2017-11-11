//
//  WatingValidMemCell.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "WatingValidMemCell.h"
#import "plantmodel.h"

#define kImgNameMargin          36

@interface WatingValidMemCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *validateBtn;
@end


@implementation WatingValidMemCell
#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

#pragma mark - private methods
//创建人color
- (void)setupUI
{
    self.validateBtn.layer.borderColor = RGBA(68,172,236,1).CGColor;
    self.validateBtn.layer.borderWidth = 1.0;
    self.validateBtn.layer.cornerRadius = 3;
    self.validateBtn.layer.masksToBounds = YES;
}

#pragma mark - selectors
- (IBAction)tapValidateBtn:(UIButton*)sender {
    sender.selected = !sender.selected;
}

#pragma mark - setters
- (void)setModel:(plantmodel *)model
{
    _model = model;
//    self.nameLabel.text = model.userName;
//    self.phoneLabel.text = model.phone;
}



@end
