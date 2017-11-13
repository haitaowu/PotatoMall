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
@property(nonatomic,assign) CGFloat imgViewHeight;
@end


@implementation PlanOptFooter
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupBase];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil){
        [self setupBase];
    }
    return self;
}

#pragma mark - set up
- (void)setupBase
{
    __block typeof(self) blockSelf = self;
    self.imgsView.imgChangeBlock = ^(NSArray *imgs, CGFloat height) {
        blockSelf.imgViewHeight = height;
        if (imgs.count > 0) {
            self.imgs = [NSMutableArray arrayWithArray:imgs];
        }
    };
}

#pragma mark - selectors
- (IBAction)tapConfirmBtn:(UIButton*)sender
{
    if (self.confirmBlock != nil) {
        self.confirmBlock();
    }
}


@end
