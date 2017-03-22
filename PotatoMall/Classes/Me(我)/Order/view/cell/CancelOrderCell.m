//
//  CancelOrderCell.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "CancelOrderCell.h"
#import "NSString+Extentsion.h"

@interface CancelOrderCell ()
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation CancelOrderCell
#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancelBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 5;
}


#pragma mark -  setter and getter methods 
- (void)setModel:(OrderModel *)model
{
    _model = model;
    self.dateLabel.text = model.createTime;
}

#pragma mark - selectors
- (IBAction)tapCancelBtn:(id)sender {
    if (self.cancelBlock != nil) {
        self.cancelBlock();
    }
}

@end
