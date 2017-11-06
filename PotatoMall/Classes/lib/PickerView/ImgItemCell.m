//
//  ImgItemCell.m
//  lepregt
//
//  Created by taotao on 6/8/16.
//  Copyright © 2016 Singer. All rights reserved.
//

#import "ImgItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ImgItemCell()
@property (weak, nonatomic) IBOutlet UIImageView *addImgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@end

@implementation ImgItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - selectors
- (IBAction)tapDeleteBtn:(id)sender {
    if(self.delImgBlock != nil){
        self.delImgBlock();
    }
}

#pragma mark - public methods
- (void)updateImg:(UIImage *)img withType:(ItemType)type
{
    _img = img;
    _itemType = type;
    if (type == ItemTypeAdd){
        self.deleteBtn.hidden = YES;
        self.imageView.hidden = YES;
        self.addImgView.hidden = NO;
    }else{
        self.deleteBtn.hidden = NO;
        self.imageView.hidden = NO;
        self.addImgView.hidden = YES;
        self.imageView.image = img;
    }
}


@end
