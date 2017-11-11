//
//  UnionedMemHeader.h
//  lepregt
//
//  Created by taotao on 28/02/2017.
//  Copyright © 2017 Singer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AminMemEditBlock)(BOOL state);
typedef void(^MemEditCanceBlock)();
typedef void(^MemEditConfirmBlock)();

@interface UnionedMemHeader : UITableViewHeaderFooterView
@property (nonatomic,copy) AminMemEditBlock adminEditBlock;
@property (nonatomic,copy) MemEditCanceBlock memEditCanceBlock;
@property (nonatomic,copy) MemEditConfirmBlock memEditConfirmBlock;

- (void)updateUIWithMemsCount:(NSInteger)count;

@end
