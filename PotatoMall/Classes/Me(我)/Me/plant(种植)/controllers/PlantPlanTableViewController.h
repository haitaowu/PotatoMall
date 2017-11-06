//
//  PlantPlanTableViewController.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "BaseTableViewController.h"

@interface PlantPlanTableViewController : BaseTableViewController{
    NSMutableArray *mlistdata;
}
@property (nonatomic,strong)NSString * unionId;
@property (nonatomic,strong)NSString * createDate;
@property (weak, nonatomic) IBOutlet UILabel *creattime;
@end
