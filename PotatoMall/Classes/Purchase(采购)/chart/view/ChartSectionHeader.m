//
//  ChartSectionHeader.m
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "ChartSectionHeader.h"

@interface ChartSectionHeader()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@end

@implementation ChartSectionHeader

#pragma mark - selectors
- (IBAction)tapSelectBtn:(UIButton*)sender {
    sender.selected = !sender.selected;
}

#pragma mark - public methods
- (void)selectAllProducts
{
    self.selectBtn.selected = YES;
}



@end
