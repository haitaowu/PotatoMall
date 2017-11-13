//
//  PlanOptFooter.h
//  lepregt
//
//  Created by taotao on 28/02/2017.
//  Copyright © 2017 Singer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTPickedImagesView.h"

typedef void(^OptConfirmBlock)();

@interface PlanOptFooter : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet HTPickedImagesView *imgsView;
@property (nonatomic,copy) OptConfirmBlock confirmBlock;
@property(nonatomic,strong) NSMutableArray *imgs;
@end
