//
//  PurchHotCell.h
//  lepregt
//
//  Created by taotao on 6/8/16.
//  Copyright © 2016 Singer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

typedef void(^TapItemBlock)(GoodsModel *model);

@interface PurchHotCell : UITableViewCell
@property (nonatomic,copy) TapItemBlock itemBlock;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,copy) NSArray *springHotGoods;
@end
