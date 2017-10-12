//
//  EditAddressCell.h
//  PotatoMall
//
//  Created by taotao on 08/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SetDefaultAdrBlock)(id adrInfo);
typedef void(^EditAdrBlock)(id adrInfo);
typedef void(^DeleteAdrBlock)(id adrInfo);

@interface EditAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderAdrLabel;
@property(nonatomic,strong) NSDictionary *adrInfo;
@property (nonatomic,copy) SetDefaultAdrBlock defaultAdrBlock;
@property (nonatomic,copy) EditAdrBlock editAdrBlock;
@property (nonatomic,copy) DeleteAdrBlock deleteAdrBlock;

@end
