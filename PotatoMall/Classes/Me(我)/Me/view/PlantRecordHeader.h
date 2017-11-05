//
//  PlantRecordHeader.h
//  lepregt
//
//  Created by taotao on 28/02/2017.
//  Copyright © 2017 Singer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "plantmodel.h"

typedef void(^RecordOptBlock)(plantmodel *model);

@interface PlantRecordHeader : UITableViewHeaderFooterView
@property (nonatomic,copy) RecordOptBlock optBlock;
@property(nonatomic,strong) plantmodel *model;
@end
