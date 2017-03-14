//
//  AritcleDetailController.m
//  PotatoMall
//
//  Created by taotao on 25/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "AritcleDetailController.h"
#import "ArticleDetailModel.h"
#import "WXApi.h"

@interface AritcleDetailController ()<UIActionSheetDelegate>
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


#pragma mark - selectors
- (IBAction)tapShareItem:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"分享到朋友圈",@"分享到朋友",nil];
    [actionSheet showInView:self.view];
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
            }
        } reqFail:^(int type, NSString *msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}


#pragma mark - UIAction sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int scene = -1;
    switch (buttonIndex) {
        case 0:
            scene = WXSceneTimeline;
            break;
        case 1:
            scene = WXSceneSession;
            break;
        default:
            break;
    }
    
    if (scene != -1) {
        [CommHelper shareUrlWithScene:scene title:self.paramModel.title description:self.paramModel.descrpt image:[UIImage imageNamed:@"goods_placehodler"] url:@"www.baidu.com"];
    }
}





@end
