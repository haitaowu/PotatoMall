//
//  PregnantLessionHeader.h
//  lepregt
//
//  Created by taotao on 6/25/16.
//  Copyright © 2016 Singer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MoreBlock)();

@interface PurSectionHeader :UIView
- (instancetype)initWithTitle:(NSString*)title moreTitle:(NSString*)morTitle;
@property (nonatomic,copy) MoreBlock moreBlock;
@end
