//
//  UnionedMemCell.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class plantmodel;
typedef void(^AddAmdinMemberBlock) (plantmodel *model);
typedef void(^DelAmdinMemberBlock) (plantmodel *model);

@interface UnionedMemCell : UITableViewCell
@property(nonatomic,strong) plantmodel *model;
@property(nonatomic,strong) plantmodel *obserModel;
@property(nonatomic,copy) AddAmdinMemberBlock addAdminBlock;
@property(nonatomic,copy) AddAmdinMemberBlock delAdminBlock;
@end
