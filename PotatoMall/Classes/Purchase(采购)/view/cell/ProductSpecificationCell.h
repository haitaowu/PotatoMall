//
//  ProductSpecificationCell.h
//  PotatoMall
//
//  Created by taotao on 06/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecButton.h"
#import "GoodsDetailModel.h"

typedef void(^SelectSpecifBlock)(id specInfo);

@interface ProductSpecificationCell : UITableViewCell
@property (nonatomic,strong)GoodsDetailModel *detailModel;
@property (nonatomic,copy)SelectSpecifBlock  specBlock;
+ (CGFloat)cellHieghtWithCount:(NSInteger)count;
@end
