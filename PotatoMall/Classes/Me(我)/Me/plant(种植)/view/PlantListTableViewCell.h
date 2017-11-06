//
//  PlantListTableViewCell.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "plantmodel.h"

typedef void(^TapPlanOptBlock) (plantmodel *model);


@interface PlantListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *cellclickbutton;
@property(nonatomic,strong) plantmodel *model;
@property(nonatomic,copy) TapPlanOptBlock optBlock;

@end
