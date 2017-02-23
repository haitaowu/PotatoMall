//
//  HTCustomeSearchBar.h
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BeginEditingBlock)();

@interface HTCustomeSearchBar : UITextField<UITextFieldDelegate>
- (instancetype)initWithPlaceholder:(NSString*)placeholder;
+ (instancetype)searchbarWithPlaceholder:(NSString*)placeholder editBlock:(BeginEditingBlock)editBlock;
- (void)updatePlaceholder:(NSString*)placeholder;
@end
