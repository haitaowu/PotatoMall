//
//  RequestUtil.h
//  Jingtum
//
//  Created by sunbinbin on 15/5/11.
//  Copyright (c) 2015年 OpenCoin Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


//-6乐观锁异常;1:业务参数不符合要求(格式未通过校验)"

typedef enum{
    StatusTypFail = 1000,               //操作失败
    StatusTypSuccess = 1001,            //操作成功
    StatusTypNetWorkError = 1,          //1网络联接问题
    StatusTypLoginTimeout = 2001,       //登录超时
}StatusType;



typedef void(^ReqSucess)(int status,NSString* msg,id data);
typedef void(^ReqFail)(int type,NSString* msg);


@interface RequestUtil : NSObject



/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param fail 请求失败后的回调
 */
+ (void)POSTWithURL:(NSString *)url params:(id)params reqSuccess:(ReqSucess)success reqFail:(ReqFail)fail;


/**
 *  发送一个POST请求 带有头像参数
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param fail 请求失败后的回调
 */

+ (void)POSTUserWithURL:(NSString *)url params:(id)params image:(UIImage*)img reqSuccess:(ReqSucess)success reqFail:(ReqFail)fail;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


//+ (void)isConnect;

/**
 *检测网络是否可用
 */
+ (BOOL)networkAvaliable;
@end
