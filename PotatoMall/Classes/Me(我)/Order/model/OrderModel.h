//
//  OrderModel.h
//  PotatoMall
//
//  Created by taotao on 09/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
/** 创建日期*/
@property (nonatomic,copy) NSString *createTime;

/** 订单编码*/
@property (nonatomic,copy) NSString *orderCode;

/** 订单ID*/
@property (nonatomic,copy) NSString *orderId;

/** 1在线支付 0货到付款*/
@property (nonatomic,strong) NSNumber *orderLinePay;

/** 订单总价*/
@property (nonatomic,copy) NSString *orderPrice;

/* *0未付款 1已付款未发货 2已发货 3已经收货 4作废 7:退货审核中 8：同意退货 9:拒绝退货 10:待商家收货 11:订单结束 12:同意退款 * 13： 拒绝退款 14:已提交退货审核 15：已提交退款审核 16: 商家收货失败 17:已退款 18:申请退款 退款成功
  */
/** 订单状态*/
@property (nonatomic,copy) NSString *orderStatus;

/**ht 订单中文状态*/
@property (nonatomic,copy) NSString *orderStatusZH;

/** 订单备注*/
@property (nonatomic,copy) NSString *remark;

/** 发货日期*/
@property (nonatomic,strong) NSNumber *sendExpressTime;

/** 联系电话*/
@property (nonatomic,copy) NSString *shippingMobile;

/** 联系人*/
@property (nonatomic,copy) NSString *shippingPerson;

/** 用户ID*/
@property (nonatomic,copy) NSString *userId;

/** 价格是否修改过*/
@property (nonatomic,copy) NSString *isUpdate;

/** 货品对象集合*/
@property (nonatomic,strong) NSArray *list;





+ (NSMutableArray*)ordersWithData:(id)data;

@end
