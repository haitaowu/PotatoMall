//
//  PlanFollowHeader.m
//  lepregt
//
//  Created by taotao on 28/02/2017.
//  Copyright © 2017 Singer. All rights reserved.
//

#import "PlanFollowHeader.h"


@interface PlanFollowHeader()
@property (nonatomic,weak)UILabel  *dataLabel;
@property (nonatomic,weak)UIButton  *helpView;
@end


@implementation PlanFollowHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil){
    }
    return self;
}

#pragma mark - selectors
- (IBAction)tapOptionHelp:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (self.openStateBlock != nil) {
        self.openStateBlock(sender.selected);
    }
}


@end
