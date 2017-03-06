//
//  HTSearchHistoryController.h
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickSearchBlock)(NSString *word);

@interface HTSearchHistoryController : UIViewController<UISearchBarDelegate>
@property (nonatomic,copy) ClickSearchBlock searchBlock;
@property (nonatomic,copy) NSString *location;
@end
