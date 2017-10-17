//
//  SearchCell.m
//  PotatoMall
//
//  Created by taotao on 28/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark -  setter and getter methods 
- (void)setRecord:(NSDictionary *)record
{
    _record = record;
    NSString *title = [record objectForKey:kColTitle];
    self.titleLabel.text = title;
}

#pragma mark - selectors
- (IBAction)tapDeleteBtn:(id)sender {
    if (self.deleteBlock != nil) {
        self.deleteBlock(self.record);
    }
}


@end
