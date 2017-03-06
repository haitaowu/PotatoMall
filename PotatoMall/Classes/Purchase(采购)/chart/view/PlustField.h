//
//  PlustField.h
//  PotatoMall
//
//  Created by taotao on 04/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PlusBlock)(NSString *countStr);
typedef void(^MinusBlock)(NSString *countStr);



@interface PlustField : UITextField
@property (nonatomic,copy)PlusBlock  plusBlock;
@property (nonatomic,copy)MinusBlock  minusBlock;

@end
