//
//  UnionedMemCell.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "UnionedMemCell.h"
#import "plantmodel.h"

#define kImgNameMargin          36

@interface UnionedMemCell()
@property (weak, nonatomic) IBOutlet UIImageView *logoimage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *roleType;
@property (weak, nonatomic) IBOutlet UIButton *choiceBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingMargin;
@end


@implementation UnionedMemCell
#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark - private methods
//创建人color
- (UIColor*)builderLabelColor
{
    UIColor *color = RGBA(68,172,236,1);
    return color;
}

#pragma mark - selectors
- (IBAction)tapChoiceBtn:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.model.isSetAdmin = YES;
        self.model.unionType = @"2";
        if (self.addAdminBlock != nil) {
            self.addAdminBlock(self.model);
        }
    }else{
        self.model.isSetAdmin = NO;
        self.model.unionType = @"3";
        if (self.delAdminBlock != nil) {
            self.delAdminBlock(self.model);
        }
    }
}

#pragma mark - setters
- (void)setModel:(plantmodel *)model
{
    _model = model;
    self.nameLabel.text = model.userName;
    self.phoneLabel.text = model.phone;
    self.choiceBtn.selected = model.isSetAdmin;
    if([model.unionType isEqualToString:@"1"]){
        self.leadingMargin.constant = 0;
        self.roleType.hidden = NO;
        [self.roleType setBackgroundColor:[self builderLabelColor]];
        [self.roleType setTitle:@"创建人" forState:UIControlStateNormal];
        self.leadingMargin.constant = 0;
    }else if([model.unionType isEqualToString:@"2"]){
        [self.roleType setBackgroundColor:kMainNavigationBarColor];
        [self.roleType setTitle:@"管理员" forState:UIControlStateNormal];
        if (model.isEditing == YES){
            self.leadingMargin.constant = kImgNameMargin;
            if (model.isSetAdmin == YES){
                self.roleType.hidden = NO;
            }else{
                self.roleType.hidden = YES;
            }
        }else{
            self.leadingMargin.constant = 0;
            self.roleType.hidden = NO;
        }
    }else {
        [self.roleType setBackgroundColor:[UIColor blueColor]];
        [self.roleType setTitle:@"普通用户" forState:UIControlStateNormal];
        if (model.isEditing == YES) {
            self.leadingMargin.constant = kImgNameMargin;
            self.roleType.hidden = YES;
        }else{
            self.leadingMargin.constant = 0;
            self.roleType.hidden = YES;
        }
    }
    
    
    //    NSURL *photourl = [NSURL URLWithString:model.headPic];
    //url请求实在UI主线程中进行的
    //    UIImage *images = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl]];
    //    cell.logoimage.image = images;
    if (model.headPic != nil) {
        NSURL *picUrl = [NSURL URLWithString:model.headPic];
        UIImage *holderImg = [UIImage imageNamed:@"farmer"];
        [self.logoimage sd_setImageWithURL:picUrl placeholderImage:holderImg];
    }
}

- (void)setObserModel:(plantmodel *)obserModel
{
    _obserModel = obserModel;
    self.nameLabel.text = obserModel.userName;
    self.phoneLabel.text = obserModel.phone;
    [self.roleType setBackgroundColor:kMainNavigationBarColor];
    [self.roleType setTitle:@"观察员" forState:UIControlStateNormal];
    self.leadingMargin.constant = 0;
    self.roleType.hidden = NO;
    
    if (obserModel.headPic != nil) {
        NSURL *picUrl = [NSURL URLWithString:obserModel.headPic];
        UIImage *holderImg = [UIImage imageNamed:@"farmer"];
        [self.logoimage sd_setImageWithURL:picUrl placeholderImage:holderImg];
    }
}


@end
