//
//  PregnantLessionHeader.h
//  lepregt
//
//  Created by taotao on 6/25/16.
//  Copyright © 2016 Singer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    DefaultLineType = 0,
    TopLineType = 1,
    BottomLineType = 2
}LineType;


@interface SectionHeaderTitle :UIView
- (instancetype)initWithTitle:(NSString*)title;
@end
