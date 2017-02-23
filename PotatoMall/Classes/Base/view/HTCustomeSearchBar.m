//
//  HTCustomeSearchBar.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "HTCustomeSearchBar.h"

@interface HTCustomeSearchBar()
@property (nonatomic,copy)BeginEditingBlock  editBlock;
@end

@implementation HTCustomeSearchBar

+ (instancetype)searchbarWithPlaceholder:(NSString*)placeholder editBlock:(BeginEditingBlock)editBlock
{
    HTCustomeSearchBar *searchBar = [[[self class] alloc] initWithPlaceholder:placeholder];
    searchBar.editBlock = editBlock;
    return searchBar;
}

- (instancetype)initWithPlaceholder:(NSString*)placeholder
{
    self = [super init];
    if (self) {
        [self setupUIWithPlaceholder:placeholder];
    }
    return self;
}

// 控制还未输入时文本的位置，缩进40
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds, 30, 0);
}

// 控制输入后文本的位置，缩进20
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds, 30, 0);
}


- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect rect = [super leftViewRectForBounds:bounds];
    rect.origin.x = rect.origin.x + 5;
    return rect;
}

#pragma mark - setup ui
- (void)setupUIWithPlaceholder:(NSString*)placeholder
{
    self.delegate = self;
    CGFloat seachbarWith = kScreenWidth * 0.9;
    CGFloat seachbarHeight = 30;
    self.size = CGSizeMake(seachbarWith, seachbarHeight);
    UIImageView *leftV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_search"]];
//    leftV.backgroundColor = [UIColor greenColor];
    leftV.contentMode = UIViewContentModeScaleAspectFit;
    self.leftView = leftV;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.font = [UIFont systemFontOfSize:13];

    NSDictionary *attris = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:13],NSFontAttributeName,nil];
    NSAttributedString *attriStrHolder = [[NSAttributedString alloc] initWithString:placeholder attributes:attris];
    self.attributedPlaceholder = attriStrHolder;
    self.backgroundColor = kSearchBarBGColor;
    self.layer.cornerRadius = seachbarHeight * 0.15;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"UITextFieldDelegate ");
    if (self.editBlock != nil) {
        self.editBlock();
    }
    return NO;
}


/*    NSMutableParagraphStyle *style = [self.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.minimumLineHeight = self.font.lineHeight - (self.font.lineHeight - [UIFont systemFontOfSize:13].lineHeight) / 2.0 + 1;
    NSDictionary *attris = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:13],NSFontAttributeName,style,NSParagraphStyleAttributeName,nil];

 */

@end
