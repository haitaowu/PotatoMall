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


@implementation RequestUtil

#pragma mark - public methods
//ht 请求数据
+ (void)POSTWithURL:(NSString *)url params:(id)params reqSuccess:(ReqSucess)success reqFail:(ReqFail)fail
{
    NSMutableDictionary *finalParams = [self globalParamsWith:params];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 18;
    [manager POST:url parameters:finalParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *codeNum = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        if ([codeNum intValue] == StatusTypSuccess) {
            success(StatusTypSuccess,msg,nil);
        }else{
            fail([codeNum intValue],msg);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(StatusTypNetWorkError,@"网络连接问题");
    }];
    
}


+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    NSString *encytData = [self encrytWithData:params];
    globalParms[kData] = encytData;
    return globalParms;
    
}

+ (NSString*)encrytWithData:(id) data
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
