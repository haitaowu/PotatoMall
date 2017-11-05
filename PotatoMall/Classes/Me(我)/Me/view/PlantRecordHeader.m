//
//  PlantRecordHeader.m
//  lepregt
//
//  Created by taotao on 28/02/2017.
//  Copyright © 2017 Singer. All rights reserved.
//

#import "PlantRecordHeader.h"


@interface PlantRecordHeader()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic,weak)IBOutlet UILabel  *nameLabel;
@property (nonatomic,weak)IBOutlet UIButton  *stateBtn;
@end


@implementation PlantRecordHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil){
    }
    return self;
}

- (void)setModel:(plantmodel *)model
{
    _model = model;
    if (model.isOpened == YES) {
        [self.stateBtn setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        [self.stateBtn setTitle:@"展开" forState:UIControlStateNormal];
    }
    
    NSString *dateStr = [self dateStrWithIntStr:model.platDate];
    self.dateLabel.text= dateStr;
    
    self.nameLabel.text = model.name;
}

- (NSString*)dateStrWithIntStr:(NSString*)intervalStr
{
    //时间戳转化为时间NSDate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    
    NSTimeInterval interval = [intervalStr doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
    
}

#pragma mark - selectors
- (IBAction)tapStateBtn:(UIButton*)sender
{
    self.model.isOpened = !self.model.isOpened;
    if (self.optBlock != nil) {
        self.optBlock(self.model);
    }
}


@end
