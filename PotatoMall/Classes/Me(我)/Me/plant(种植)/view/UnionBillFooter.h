//
//  UnionBillFooter.h
//  lepregt
//
//  Created by taotao on 28/02/2017.
//  Copyright © 2017 Singer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BillDetailBlock)();

@interface UnionBillFooter : UITableViewHeaderFooterView
@property (nonatomic,copy) BillDetailBlock billDetailBlock;

@end
