//
//  MeMenuCell.m
//  PotatoMall
//
//  Created by taotao on 27/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "MeMenuCell.h"


@interface MeMenuCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@end


@implementation MeMenuCell

#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark -  setter and getter methods 
- (void)setMenuData:(NSDictionary *)menuData indexPath:(NSIndexPath*)indexPath
{
    _menuData = menuData;
    NSString *imgName = [menuData objectForKey:kImageKey];
    UIImage *img = [UIImage imageNamed:imgName];
    self.iconView.image = img;
    // set up title
    NSString *title = [menuData objectForKey:kTitleKey];
    self.titleLabel.text = title;
    self.separatorLine.hidden = YES;
    if ((indexPath.section == 0) || (indexPath.section == 1)){
//        self.separatorLine.hidden = NO;
    }else{
//        self.separatorLine.hidden = YES;
    }
}


@end
