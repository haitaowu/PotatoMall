//
//  AdCollectionCell.h
//  lepregt
//
//  Created by taotao on 6/8/16.
//  Copyright © 2016 Singer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong)NSDictionary *adData;

@end
