//
//  PlantInfoControllerViewController.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/6.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseTableViewController.h"

@interface PlantInfoControllerViewController : BaseTableViewController<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSDictionary *data;
    NSMutableArray *type0;
    NSMutableArray *type1;
    NSMutableArray *type2;
    NSString *cropName;
    NSString *platType;
    NSString *platSource;
}
@property (weak, nonatomic) IBOutlet UITextField *addresstextfield;//地址
@property (weak, nonatomic) IBOutlet UITextField *numtextfield;//数量
@property (weak, nonatomic) IBOutlet UIButton *lastmodelbutton;//上茶作物
@property (weak, nonatomic) IBOutlet UIButton *zhongsubutton;//中🍠
@property (weak, nonatomic) IBOutlet UIButton *laiyuanbutton; //来源
@property (nonatomic,strong)UIPickerView * pickerView;
@property (nonatomic,nonatomic)NSString *canclick;
@property (weak, nonatomic) IBOutlet UITableViewCell *buttoncell;

- (IBAction)lastbuttonclick:(id)sender;

@end
