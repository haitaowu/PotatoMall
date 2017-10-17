//
//  AddAdrFuncCell.h
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddAddressBlock)();


@interface AddAdrFuncCell : UITableViewCell

@property (nonatomic,copy) AddAddressBlock addAddressBlock;
@end
