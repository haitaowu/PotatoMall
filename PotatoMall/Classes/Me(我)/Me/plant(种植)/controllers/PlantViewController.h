//
//  PlantViewController.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/6.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
@interface PlantViewController : BaseTableViewController{
//    NSString *unionId;
//    Boolean selection0;
    NSString *message;
}
@property (weak, nonatomic) IBOutlet UITableViewCell *nocell;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell1;
@property (weak, nonatomic) IBOutlet UIButton *mstatebutton;



@end
