//
//  PlanOptFooter.m
//  lepregt
//
//  Created by taotao on 28/02/2017.
//  Copyright © 2017 Singer. All rights reserved.
//

#import "PlanOptFooter.h"


@interface PlanOptFooter()
@property (nonatomic,weak)UILabel  *dataLabel;
@property (nonatomic,weak)UIButton  *helpView;
@end


@implementation PlanOptFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil){
    }
    return self;
}

#pragma mark - selectors
- (IBAction)tapConfirmBtn:(UIButton*)sender
{
    if (self.confirmBlock != nil) {
        self.confirmBlock();
    }
}


@end
