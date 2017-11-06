//
//  PlanthandleViewController.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/20.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "BaseViewController.h"

@interface PlanthandleViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    NSDictionary *data;
    NSMutableArray *type0;
    NSMutableArray *type1;
    NSMutableArray *type2;
    NSString *cropName;
    NSString *platType;
    NSString *platSource;
    
    NSMutableArray *mlistdata;
    NSString *murl;
    __weak IBOutlet UIButton *openbutton;
    Boolean state;
    __weak IBOutlet UIButton *uploadimage;
}
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *arealabel;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (nonatomic,strong)NSString * unionId;
@end
