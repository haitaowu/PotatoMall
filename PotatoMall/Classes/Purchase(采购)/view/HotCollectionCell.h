//
//  HotCollectionCell.h
//  lepregt
//
//  Created by taotao on 6/8/16.
//  Copyright © 2016 Singer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsModel;

@interface HotCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,copy) GoodsModel *model;

@end
