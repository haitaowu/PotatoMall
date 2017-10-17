//
//  OrderAddressCell.m
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "OrderAddressCell.h"
#import "NSDictionary+Extension.h"

@interface OrderAddressCell ()
@property (unsafe_unretained, nonatomic) IBOutlet TitleLabel *reciverLabel;
@property (unsafe_unretained, nonatomic) IBOutlet TitleLabel *phoneLabel;
@property (unsafe_unretained, nonatomic) IBOutlet TitleLabel *adrLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *hasAdrView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *hasNoAdrView;

@end

@implementation OrderAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - setter
- (void)setAdrInfo:(NSDictionary *)adrInfo
{
    _adrInfo = adrInfo;
    if (adrInfo == nil) {
        self.hasAdrView.hidden = YES;
        self.hasNoAdrView.hidden = NO;
        
    }else{
        self.hasAdrView.hidden = NO;
        self.hasNoAdrView.hidden = YES;
        self.reciverLabel.text = [adrInfo strValueForKey:@"addressName"];
        self.phoneLabel.text = [adrInfo strValueForKey:@"addressMoblie"];
        NSString *addressProvinceName = [adrInfo strValueForKey:@"addressProvinceName"];
        NSString *addressCityName = [adrInfo strValueForKey:@"addressCityName"];
        NSString *addressCountyName = [adrInfo strValueForKey:@"addressCountyName"];
        NSString *addressDetail = [adrInfo strValueForKey:@"addressDetail"];
        NSString *adrDetail = [NSString stringWithFormat:@"%@%@%@%@",addressProvinceName,addressCityName,addressCountyName,addressDetail];
        self.adrLabel.text = adrDetail;
    }
}

@end
