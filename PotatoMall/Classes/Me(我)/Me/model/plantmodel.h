//
//  plantmodel.h
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/8.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface plantmodel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *catalogName;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *helpUrl;
@property (nonatomic,copy) NSString *platDate;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *headPic;
@property (nonatomic,copy) NSString *userType;
@property (nonatomic,copy) NSString *unionType;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,copy) NSString *score;
@property (nonatomic,copy) NSString *imagesUrls;
@property (nonatomic,copy) NSString *verifyStatu;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *platTemplateDetailId;
@property (nonatomic,copy) NSString *platSendRecordId;
@property(nonatomic,assign) BOOL isOpened;

/**
 *merber cell status property
 */
@property(nonatomic,assign) BOOL isEditing;
@property(nonatomic,assign) BOOL isSetAdmin;


+ (NSDictionary*)plantWithData:(id)data;
+ (NSMutableArray*)plantWithDataArray:(id)data;
+ (NSMutableArray*)plantWithDataArray1:(id)data;
@end
