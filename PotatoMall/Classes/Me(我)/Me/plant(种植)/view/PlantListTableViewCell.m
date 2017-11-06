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
//    self.title.text=model.content;
    NSString *title = [self titleWithIntervalStr:model.platDate];
    self.content.text=model.catalogName;
    
    self.title.text = title;
    if ([title containsString:@"过期"]) {
        self.content.textColor = [UIColor redColor];
    }else{
        self.content.textColor = [UIColor blackColor];
    }
//    murl=model.helpUrl;
}

- (NSString*)titleWithIntervalStr:(NSString*)intervalStr
{
    if (intervalStr == nil) {
        return @"";
    }
    NSDate *plateDate = [self dateStrWithIntStr:intervalStr];
    NSDate *today = [NSDate date];
    NSTimeInterval interval = [plateDate timeIntervalSinceDate:today];
    if (interval < 0) {
        NSInteger dayCount = ABS(interval / (24 * 60 * 60));
        NSString *title = [NSString stringWithFormat:@"过期%ld",dayCount];
        return title;
    }else{
        NSInteger dayCount = ABS(interval / (24 * 60 * 60));
        NSString *title = [NSString stringWithFormat:@"%ld天后",dayCount];
        return title;
    }
}

- (NSDate*)dateStrWithIntStr:(NSString*)intervalStr
{
    //时间戳转化为时间NSDate
    NSTimeInterval interval = [intervalStr doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
    
}
@end
