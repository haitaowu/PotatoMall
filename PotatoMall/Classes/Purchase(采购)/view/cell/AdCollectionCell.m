//
//  AdCollectionCell.m
//  lepregt
//
//  Created by taotao on 6/8/16.
//  Copyright © 2016 Singer. All rights reserved.
//

#import "AdCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation AdCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAdData:(NSDictionary *)adData
{
    _adData = adData;
    UIImage *imgHolder = [UIImage imageNamed:@"palcehodler_C"];
    NSString *imageUrl = [adData objectForKey:@"advImage"];
    if (![imageUrl isKindOfClass:[NSNull class]]) {
        NSURL *url = [NSURL URLWithString:imageUrl];
        [self.imageView sd_setImageWithURL:url placeholderImage:imgHolder];
    }else{
        self.imageView.image = imgHolder;
    }
}


@end
