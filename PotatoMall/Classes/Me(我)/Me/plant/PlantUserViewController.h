//
//  PlantUserViewController.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface PlantUserViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *mlistdata;
}
@property (weak, nonatomic) IBOutlet UIImageView *logoimage;
@property (weak, nonatomic) IBOutlet UILabel *cellphone;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (nonatomic,strong)NSString * unionId;
@property (weak, nonatomic) IBOutlet UILabel *numlabel0;
@property (weak, nonatomic) IBOutlet UILabel *numlabel2;
@property (weak, nonatomic) IBOutlet UIButton *managebutton;
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@end
