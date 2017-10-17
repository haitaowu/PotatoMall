//
//  AddMofityAdrTableController.h
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "BaseTableViewController.h"

typedef enum{
    ReviceAdrTypeAdd,
    ReviceAdrTypeModify
} ReviceAdrType;

@interface AddMofityAdrTableController : BaseTableViewController
@property(nonatomic,strong) NSDictionary *adrInfo;
@property(nonatomic,assign) ReviceAdrType editType;
@end
