//
//  PlanOptFooter.h
//  lepregt
//
//  Created by taotao on 28/02/2017.
//  Copyright © 2017 Singer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OptConfirmBlock)();

@interface PlanOptFooter : UITableViewHeaderFooterView
@property (nonatomic,copy) OptConfirmBlock confirmBlock;
@end
