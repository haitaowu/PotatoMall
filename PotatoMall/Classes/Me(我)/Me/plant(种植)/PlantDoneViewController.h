//
//  PlantDoneViewController.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/21.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "BaseViewController.h"

@interface PlantDoneViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (nonatomic,strong)NSMutableArray * mlistdata;
@property (nonatomic,strong)NSString * unionId;
@end
