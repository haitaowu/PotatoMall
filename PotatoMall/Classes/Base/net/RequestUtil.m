//
//  RequestUtil.m
//  Jingtum
//
//  Created by sunbinbin on 15/5/11.
//  Copyright (c) 2015年 OpenCoin Inc. All rights reserved.
//

#import "RequestUtil.h"
#import "SecurityUtil.h"
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"
#import "AppInfoHelper.h"


#define kRequestTimerout            15

@implementation RequestUtil

#pragma mark - public methods
//ht 请求数据
+ (void)POSTWithURL:(NSString *)url params:(id)params reqSuccess:(ReqSucess)success reqFail:(ReqFail)fail
{
    NSMutableDictionary *finalParams = [self globalParamsWith:params];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kRequestTimerout;
    [manager POST:url parameters:finalParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *codeNum = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        id data = responseObject[@"data"];
        if ([codeNum intValue] == StatusTypSuccess) {
            success(StatusTypSuccess,msg,data);
        }else if ([codeNum intValue] == StatusTypLoginTimeout) {
            [self reLoginWith:url params:finalParams reqSuccess:success reqFail:fail];
        }else{
            fail([codeNum intValue],msg);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(StatusTypNetWorkError,@"网络连接问题");
    }];
    
}

//ht 请求服务器 带有附件。
+ (void)POSTWithURL:(NSString *)url params:(id)params attach:(UIImage*)img reqSuccess:(ReqSucess)success reqFail:(ReqFail)fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *finalParams = [self globalParamsWith:params];
    NSData *imgData = UIImagePNGRepresentation(img);
    finalParams[@"avatar"] = [[NSString alloc] initWithData:imgData encoding:NSUTF8StringEncoding];
    manager.requestSerializer.timeoutInterval = kRequestTimerout;
    [manager POST:url parameters:finalParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (img != nil) {
            NSData *imgData = UIImagePNGRepresentation(img);
            if (img != nil) {
                [formData appendPartWithFileData:imgData name:@"avatar" fileName:@"avatar.png" mimeType:@"image/png"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *codeNum = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        id data = responseObject[@"data"];
        if ([codeNum intValue] == StatusTypSuccess) {
            success(StatusTypSuccess,msg,data);
        }else{
            fail([codeNum intValue],msg);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(StatusTypNetWorkError,@"网络连接问题");
    }];
}


//ht 请求数据修改个人信息 带有头像。
+ (void)POSTUserWithURL:(NSString *)url params:(id)params image:(UIImage*)img reqSuccess:(ReqSucess)success reqFail:(ReqFail)fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *finalParams = [self globalParamsWith:params];
//    NSData *imgData = UIImagePNGRepresentation(img);
//    finalParams[@"avatar"] = [[NSString alloc] initWithData:imgData encoding:NSUTF8StringEncoding];
    manager.requestSerializer.timeoutInterval = kRequestTimerout;
    [manager POST:url parameters:finalParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imgData = UIImagePNGRepresentation(img);
        if (img != nil) {
            [formData appendPartWithFileData:imgData name:@"avatar" fileName:@"avatar.png" mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *codeNum = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        id data = responseObject[@"data"];
        if ([codeNum intValue] == StatusTypSuccess) {
            success(StatusTypSuccess,msg,data);
        }else{
            fail([codeNum intValue],msg);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(StatusTypNetWorkError,@"网络连接问题");
    }];
}


/**
 *  发送一个POST请求 请求服务器 带有多个图片
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param fail 请求失败后的回调
 */
+ (void)POSTWithURL:(NSString *)url params:(id)params attachs:(NSArray*)attachs reqSuccess:(ReqSucess)success reqFail:(ReqFail)fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *finalParams = [self globalParamsWith:params];
    NSMutableArray *imgDatas = [NSMutableArray array];
    for (UIImage *img in attachs) {
        NSData *oneData = UIImagePNGRepresentation(img);
        [imgDatas addObject:oneData];
    }
    manager.requestSerializer.timeoutInterval = kRequestTimerout;
    [manager POST:url parameters:finalParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imgDatas.count; i++) {
            NSData *imgData = imgDatas[i];
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.png", dateString];
            [formData appendPartWithFileData:imgData name:@"picfiles" fileName:fileName mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *codeNum = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        id data = responseObject[@"data"];
        if ([codeNum intValue] == StatusTypSuccess) {
            success(StatusTypSuccess,msg,data);
        }else{
            fail([codeNum intValue],msg);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(StatusTypNetWorkError,@"网络连接问题");
    }];
}


//ht重新登录获取
+ (void)reLoginWith:(NSString *)url params:(id)params reqSuccess:(ReqSucess)success reqFail:(ReqFail)fail
{
    NSString *accountTxt = [UserModelUtil userAccount];
    NSString *pwdTxt = [UserModelUtil userPassword];
    NSString *subUrl = @"user/login";
    NSString *loginUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
     NSDictionary *loginParams = [NSDictionary dictionaryWithObjectsAndKeys:accountTxt,kAccount,pwdTxt,kPassword, nil];
    
   NSMutableDictionary *finalParams = [self globalParamsWith:loginParams];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:loginUrl parameters:finalParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *codeNum = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        if ([codeNum intValue] == StatusTypSuccess) {
            [self requestDataWithLastUrl:url parameter:params reqSuccess:success reqFail:fail];
        }else{
            fail([codeNum intValue],msg);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(StatusTypNetWorkError,@"网络连接问题");
    }];
}


//ht重新取得token后重新请求数据
+ (void)requestDataWithLastUrl:(NSString*)url parameter:(id)params reqSuccess:(ReqSucess)success reqFail:(ReqFail)fail{
    // 1.创建请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kRequestTimerout;
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self processResonse:responseObject url:url reqSuccess:success reqFail:fail];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(StatusTypNetWorkError,@"网络不给力哦");
    }];
}


//ht 处理请求结果
+ (void)processResonse:(id)responseObject url:(NSString*)url reqSuccess:(ReqSucess)success reqFail:(ReqFail)fail
{
    NSNumber *codeNum = responseObject[@"code"];
    NSString *msg = responseObject[@"msg"];
    id data = responseObject[@"data"];
    if ([codeNum intValue] == StatusTypSuccess) {
        success(StatusTypSuccess,msg,data);
    }else{
        fail([codeNum intValue],msg);
    }
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *finalParams = [self globalParamsWith:params];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [manager POST:url parameters:finalParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
        }
    }];
}

#pragma mark - private methods
+ (NSMutableDictionary*)globalParamsWith:(NSDictionary*)params
{
    NSMutableDictionary *globalParms = [NSMutableDictionary dictionary];
    globalParms[kDeviceTokenKey] = [AppInfoHelper currentDeviceIdentifier];
    globalParms[kVersionKey] = [AppInfoHelper shortVersionString];
    if (params != nil) {
        NSString *encytDataStr = [self encrytWithData:params];
        globalParms[kData] = encytDataStr;
    }
    return globalParms;
}

+ (NSString*)encrytWithData:(id) data
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *encrytStr = [SecurityUtil encryptAESData:jsonStr];
    return encrytStr;
}

#pragma mark - 判断有没有网络
//+ (void)isConnect
//{
//    BOOL isNetWork=NO;
//    Reachability *reach = [Reachability reachabilityForInternetConnection];
//    switch ([reach currentReachabilityStatus]) {
//        case NotReachable:
//        {
//            isNetWork=YES;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络状态" message:@"没有网络，请检查网路" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil];
//            [alert show];
//            break;
//        }
//        case ReachableViaWiFi:
//            break;
//        case ReachableViaWWAN:
//            break;
//    }
//    if (!isNetWork)
//    {
//        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器错误,请稍后再试" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil];
//        //        [alert show];
//    }
//    
//}
//

+ (BOOL)networkAvaliable
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if([reach currentReachabilityStatus] == NotReachable){
        return NO;
    }else{
        return YES;
    }
}


@end
