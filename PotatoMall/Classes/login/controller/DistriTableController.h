//
//  DistriTableController.h
//  PotatoMall
//
//  Created by taotao on 02/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"
#import "BaseTableViewController.h"

@interface DistriTableController : BaseTableViewController
@property (nonatomic,strong)CityModel *cityModel;
@property (nonatomic,strong)CityModel *provieModel;
@end
