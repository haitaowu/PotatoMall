//
//  UnionedObserHeader.m
//  lepregt
//
//  Created by taotao on 28/02/2017.
//  Copyright © 2017 Singer. All rights reserved.
//

#import "UnionedObserHeader.h"


@interface UnionedObserHeader()
@property (weak, nonatomic) IBOutlet UILabel *obserCountLabel;

@end

@implementation UnionedObserHeader
#pragma mark - override methods
- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - public methods
- (void)updateUIWithObserCount:(NSInteger)count
{
    NSString *countStr = [NSString stringWithFormat:@"(共%ld名)",(long)count];
    self.obserCountLabel.text = countStr;
}


@end
