//
//  UnionBillFooter.m
//  lepregt
//
//  Created by taotao on 28/02/2017.
//  Copyright © 2017 Singer. All rights reserved.
//

#import "UnionBillFooter.h"


@interface UnionBillFooter()


@end


@implementation UnionBillFooter
#pragma mark - override methods
- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - selectors
- (IBAction)tapDetailBtn:(UIButton*)sender
{
    if (self.billDetailBlock != nil) {
        self.billDetailBlock();
    }
}


@end
