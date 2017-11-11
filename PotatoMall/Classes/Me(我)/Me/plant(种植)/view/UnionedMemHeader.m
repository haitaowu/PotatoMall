//
//  UnionedMemHeader.m
//  lepregt
//
//  Created by taotao on 28/02/2017.
//  Copyright © 2017 Singer. All rights reserved.
//

#import "UnionedMemHeader.h"


@interface UnionedMemHeader()
@property (weak, nonatomic) IBOutlet UILabel *memberCountLabel;
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIButton *adminBtn;
@property (weak, nonatomic) IBOutlet UIButton *confimBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic,weak)UILabel  *dataLabel;
@property (nonatomic,weak)UIButton  *helpView;

@end


@implementation UnionedMemHeader
#pragma mark - override methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}

#pragma mark - private methods
- (UIColor*)builderLabelColor
{
    UIColor *color = RGBA(68,172,236,1);
    return color;
}

#pragma mark - setup
- (void)setupView
{
    self.adminBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.adminBtn.layer.borderWidth = 1.0;
    self.adminBtn.layer.cornerRadius = 3;
    self.adminBtn.layer.masksToBounds = YES;
    
    self.confimBtn.layer.borderColor = [self builderLabelColor].CGColor;
    self.confimBtn.layer.borderWidth = 1.0;
    self.confimBtn.layer.cornerRadius = 3;
    self.confimBtn.layer.masksToBounds = YES;
    
    self.optionView.hidden = YES;
    self.adminBtn.hidden = NO;
}

#pragma mark - public methods
- (void)updateUIWithMemsCount:(NSInteger)count
{
    NSString *countStr = [NSString stringWithFormat:@"(共%ld名)",(long)count];
    self.memberCountLabel.text = countStr;
}

#pragma mark - selectors
- (IBAction)tapAmdinBtn:(UIButton*)sender
{
    if (self.adminEditBlock != nil) {
        self.adminEditBlock(YES);
    }
    self.optionView.hidden = NO;
    self.adminBtn.hidden = YES;
}

- (IBAction)tapConfirmBtn:(UIButton*)sender
{
    self.optionView.hidden = YES;
    self.adminBtn.hidden = NO;
    if (self.memEditConfirmBlock != nil) {
        self.memEditConfirmBlock();
    }
}


- (IBAction)tapCancelBtn:(UIButton*)sender
{
    self.optionView.hidden = YES;
    self.adminBtn.hidden = NO;
    if (self.memEditCanceBlock != nil) {
        self.memEditCanceBlock();
    }
}


@end
