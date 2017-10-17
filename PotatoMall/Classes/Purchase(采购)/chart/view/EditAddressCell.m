//
//  EditAddressCell.m
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "EditAddressCell.h"
#import "NSDictionary+Extension.h"

@interface EditAddressCell ()
@property (unsafe_unretained, nonatomic) IBOutlet TitleLabel *reciverLabel;
@property (unsafe_unretained, nonatomic) IBOutlet TitleLabel *phoneLabel;
@property (unsafe_unretained, nonatomic) IBOutlet TitleLabel *adrLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *defaultBtn;

@end

@implementation EditAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - setter
- (void)setAdrInfo:(NSDictionary *)adrInfo
{
    _adrInfo = adrInfo;
    self.reciverLabel.text = [adrInfo strValueForKey:@"addressName"];
    self.phoneLabel.text = [adrInfo strValueForKey:@"addressMoblie"];
    NSString *addressProvinceName = [adrInfo strValueForKey:@"addressProvinceName"];
    NSString *addressCityName = [adrInfo strValueForKey:@"addressCityName"];
    NSString *addressCountyName = [adrInfo strValueForKey:@"addressCountyName"];
    NSString *addressDetail = [adrInfo strValueForKey:@"addressDetail"];
    NSString *adrDetail = [NSString stringWithFormat:@"%@%@%@%@",addressProvinceName,addressCityName,addressCountyName,addressDetail];
    self.adrLabel.text = adrDetail;
    NSString *defaultAdr = [adrInfo strValueForKey:@"isDefault"];
    if ([defaultAdr isEqualToString:@"1"]) {
        self.defaultBtn.selected = YES;
    }else{
        self.defaultBtn.selected = NO;
    }
}

#pragma mark - selectors
- (IBAction)tapDefaultBtn:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        if (self.defaultAdrBlock != nil) {
            self.defaultAdrBlock(self.adrInfo);
        }
    }
}

- (IBAction)tapEditBtn:(id)sender {
    if (self.editAdrBlock != nil) {
        self.editAdrBlock(self.adrInfo);
    }
}
- (IBAction)tapDeleteBtn:(id)sender {
    if (self.deleteAdrBlock != nil) {
        self.deleteAdrBlock(self.adrInfo);
    }
}
@end
