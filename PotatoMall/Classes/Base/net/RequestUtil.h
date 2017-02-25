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
    StatusTypSuccess = 0,               //0通常情况下表示业务数据操作成功
    StatusTypNetWorkError = 1,          //1网络联接问题
    StatusTypeSystemMaintenance = -1,   //-1系统维护
    StatusTypeLowVersion = -2,          //-2客户端需要升级
    StatusTypeWrongInterface = -3,      //-3服务器接口错误
    StatusTypeNoAuthority = -4,         //-4客户端目前没权限访问
    StatusTypeIllegalUser= -5           //-5非法客户端
}StatusType;



typedef void(^ReqSucess)(StatusType status,NSString* msg,id list);
typedef void(^ReqFail)(StatusType type,NSString* msg);


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
