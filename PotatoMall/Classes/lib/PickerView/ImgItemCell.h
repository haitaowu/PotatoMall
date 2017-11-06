//
//  ImgItemCell.h
//  lepregt
//
//  Created by taotao on 6/8/16.
//  Copyright © 2016 Singer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ItemTypeAdd = 0,
    ItemTypeImg = 1
}ItemType;

typedef void(^DeleteImgBlock) (void);

@interface ImgItemCell : UICollectionViewCell
@property(nonatomic,strong) UIImage *img;
@property(nonatomic,assign) ItemType itemType;
@property(nonatomic,copy) DeleteImgBlock delImgBlock;
- (void)updateImg:(UIImage *)img withType:(ItemType)type;

@end
