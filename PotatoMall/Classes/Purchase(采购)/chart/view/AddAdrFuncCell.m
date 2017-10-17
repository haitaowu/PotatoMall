//
//  AddAdrFuncCell.m
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "AddAdrFuncCell.h"

@interface AddAdrFuncCell ()

@end

@implementation AddAdrFuncCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


#pragma mark - selectors
- (IBAction)tapAddAdrBtn:(id)sender
{
    if (self.addAddressBlock != nil) {
        self.addAddressBlock();
    }
}

@end
