//
//  AritcleDetailController.m
//  PotatoMall
//
//  Created by taotao on 25/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "AritcleDetailController.h"
#import "ArticleDetailModel.h"

@interface AritcleDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic,strong)ArticleDetailModel *articleModel;
@end

@implementation AritcleDetailController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kInfoId] = self.paramModel.infoId;
    [self requestAritcleDetailWith:params];
}

#pragma mark - setup UI 
- (void)setupUIWithDetail:(ArticleDetailModel*)detail
{
    self.titleLabel.text = detail.title;
    self.authorLabel.text = detail.author;
    self.dateLabel.text = detail.createDate;
    [self.webview loadHTMLString:detail.content baseURL:nil];
}

#pragma mark - requset server
- (void)requestAritcleDetailWith:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
    }else{
        NSString *subUrl = @"article/detail";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
//            [SVProgressHUD showInfoWithStatus:msg];
            if (status == StatusTypSuccess) {
                self.articleModel = [ArticleDetailModel articleDetailWithData:data];
                [self setupUIWithDetail:self.articleModel];
                HTLog(@"hello ");
            }
        } reqFail:^(int type, NSString *msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}



@end
