//
//  PlantRecordCell.h
//  PotatoMall
//
//  Created by taotao on 2017/11/5.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class plantmodel;

@interface PlantRecordCell : UITableViewCell
@property(nonatomic,strong) plantmodel *model;
- (void)updateUIWithOutImg:(plantmodel*)model;
@end
