//
//  AddressListTableController.h
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "BaseTableViewController.h"
#import "AddMofityAdrTableController.h"

@interface AddressListTableController : BaseTableViewController
@property(nonatomic,strong) NSDictionary *adrInfo;
@property(nonatomic,assign) ReviceAdrType editType;
@end
