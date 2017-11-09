//
//  PlantManageViewController.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/9.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PlantManageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *tabledata;
    NSString *time;
}
@property (weak, nonatomic) IBOutlet UILabel *mtitle;
@property (weak, nonatomic) IBOutlet UILabel *mdetail;
@property (nonatomic,strong)NSString * unionId;

@property (nonatomic,copy)NSString *planState;

@end
