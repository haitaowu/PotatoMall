//
//  UnionedBillCell.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "UnionedBillCell.h"
#import "plantmodel.h"

#define kImgNameMargin          36

@interface UnionedBillCell()
@property (weak, nonatomic) IBOutlet UIImageView *logoimage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@end


@implementation UnionedBillCell
#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - setters
- (void)setModel:(NSDictionary *)model
{
    _model = model;
    NSString *name = [model strValueForKey:@"userName"];
    self.dateLabel.text = [model strValueForKey:@"createDate"];
    self.moneyLabel.text = [model strValueForKey:@"changeMoney"];
    NSString *changeType = [model strValueForKey:@"changeType"];
    NSString *changeTypeStr = @"支付订单";
    if([changeType isEqualToString:@"17"]){
        changeTypeStr = @"退款";
    }else if([changeType isEqualToString:@"7"]){
        changeTypeStr = @"充值";
        name = @"平台充值";
    }else{
        changeTypeStr = @"支付订单";
    }
    
    self.typeLabel.text = changeTypeStr;
    self.nameLabel.text = name;
    
    if([changeType isEqualToString:@"7"]){
        UIImage *holderImg = [UIImage imageNamed:@"tudou_placeholder"];
        self.logoimage.image = holderImg;
    }else{
        NSString *headPic = [model strValueForKey:@"imageUrl"];
        if (headPic != nil) {
            NSURL *picUrl = [NSURL URLWithString:headPic];
            UIImage *holderImg = [UIImage imageNamed:@"farmer"];
            [self.logoimage sd_setImageWithURL:picUrl placeholderImage:holderImg];
        }else{
            UIImage *holderImg = [UIImage imageNamed:@"farmer"];
            self.logoimage.image = holderImg;
        }
    }
}



@end
