//
//  plantmodel.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/8.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "plantmodel.h"

@implementation plantmodel


#pragma mark - override methods
- (id)mutableCopyWithZone:(NSZone *)zone
{
    plantmodel *model = [[plantmodel allocWithZone:zone] init];
    model.name = [self.name mutableCopy];
    model.type = [self.type mutableCopy];
    model.uid = [self.uid mutableCopy];
    model.catalogName = [self.catalogName mutableCopy];
    model.content = [self.content mutableCopy];
    model.helpUrl = [self.helpUrl mutableCopy];
    model.platDate = [self.platDate mutableCopy];
    model.userName = [self.userName mutableCopy];
    model.phone = [self.phone mutableCopy];
    model.headPic = [self.headPic mutableCopy];
    model.userType = [self.userType mutableCopy];
    model.unionType = [self.unionType mutableCopy];
    model.status = [self.status mutableCopy];
    model.imagesUrls = [self.status mutableCopy];
    model.isOpened = self.isOpened;
    model.isEditing = self.isEditing;
    model.isSetAdmin = self.isSetAdmin;
    return model;
}


+ (NSDictionary*)plantWithData:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    return [dict objectForKey:@"obj"];
}

+ (NSMutableArray*)plantWithDataArray:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSArray *obj = [dict objectForKey:@"obj"];
    
    NSLog(@"obj==%@",obj);
    return [self ordersWithArray:obj];
}

+ (NSMutableArray*)plantWithDataArray1:(id)data
{
    NSDictionary *dict = [DataUtil dictionaryWithJsonStr:data];
    NSArray *obj = [[dict objectForKey:@"obj"]objectForKey:@"list"];
    
    return [self ordersWithArray:obj];
}

+ (NSMutableArray*)ordersWithArray:(id)data
{
    NSArray *orders = [plantmodel mj_objectArrayWithKeyValuesArray:data];
    return [NSMutableArray arrayWithArray:orders];
}

@end
