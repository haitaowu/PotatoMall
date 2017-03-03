//
//  MeMenuCell.h
//  PotatoMall
//
//  Created by taotao on 27/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>



#define kImageKey               @"img"
#define kTitleKey               @"title"
#define kSegueKey               @"segue"


@interface MeMenuCell : UITableViewCell
@property (nonatomic,strong)NSDictionary *menuData;
- (void)setMenuData:(NSDictionary *)menuData indexPath:(NSIndexPath*)indexPath;
@end
