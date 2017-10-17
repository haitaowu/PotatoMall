//
//  PlantInfomationTableViewController.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "BaseTableViewController.h"

@interface PlantInfomationTableViewController : BaseTableViewController
@property (weak, nonatomic) IBOutlet UILabel *createDate;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *peoplenum;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *phonenum;
@property (weak, nonatomic) IBOutlet UIImageView *_logoimage;
@property (nonatomic,strong)NSString * unionId;
@end
