//
//  SearchCell.h
//  PotatoMall
//
//  Created by taotao on 28/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataUtil.h"

typedef void(^DeleteRecordBlock)(NSDictionary *record);

@interface SearchCell : UITableViewCell
@property (nonatomic,copy) DeleteRecordBlock deleteBlock;
@property (nonatomic,strong)NSDictionary *record;
@end
