//
//  PlantPlanViewController.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface PlantPlanViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
     NSMutableArray *mlistdata;
     NSString *murl;
}
@property (weak, nonatomic) IBOutlet UIView *infoview;
@property (nonatomic,strong)NSString * unionId;
@property (nonatomic,strong)NSString * createDate;
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@end
