//
//  PlantListTableViewCell.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlantListTableViewCell.h"

@implementation PlantListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

#pragma mark - setup ui
- (void)setupUI
{
    self.cellclickbutton.layer.cornerRadius = 3;
    self.cellclickbutton.layer.borderWidth = 0.8;
    self.cellclickbutton.layer.borderColor = kMainNavigationBarColor.CGColor;
}

#pragma mark - selectors
- (IBAction)tapOptBtn:(id)sender {
    if (self.optBlock != nil) {
        self.optBlock(_model);
    }
}

#pragma mark - setter methods
- (void)setModel:(plantmodel *)model
{
    _model = model;
    self.title.text=model.content;
    self.content.text=model.catalogName;
//    murl=model.helpUrl;
}

@end
