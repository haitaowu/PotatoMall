//
//  ChartSectionHeader.h
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectAllBlock)();

@interface ChartSectionHeader : UITableViewHeaderFooterView
@property (nonatomic,copy)SelectAllBlock  selectBlock;
- (void)selectAllProducts;
@end
