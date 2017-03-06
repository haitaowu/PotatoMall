//
//  DataUtil.m
//  PotatoMall
//
//  Created by taotao on 27/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "DataUtil.h"
#import "SecurityUtil.h"
#import "FMDB.h"

#define  kLibPath       NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
#define kDataBasePath   [kLibPath stringByAppendingPathComponent:@"HomeSearch.db"]

static DataUtil *instance = nil;

@interface DataUtil()
@property (nonatomic,strong)FMDatabase *dataBase;
@end


@implementation DataUtil

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class ] alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if(self){
        [self setupDataBase];
    }
    return self;
}

#pragma mark - private methods
- (void)setupDataBase
{
    self.dataBase = [FMDatabase databaseWithPath:kDataBasePath];
    if ([_dataBase open]) {
        [self setupPurchaseSearchHistoryTable];
        [self setupHomeSearchHistoryTable];
    }else{
        HTLog(@"open Sqlite File");
    }
}

- (void)setupHomeSearchHistoryTable
{
    HTLog(@"打开数据库成功");
    //我们打开数据库之后 需要创建表格
    /*
     create table if not exists app(id varchar(32),name varchar(128),pic varchar(1024))
     */
    NSString *sql =[NSString stringWithFormat: @"create table if not exists %@ ( %@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT)",kTableName,kColID,kColTitle];
    BOOL isSuccess = [_dataBase executeUpdate:sql];
    if (isSuccess) {
        HTLog(@"create  %@ Tabel Success",kTableName);
    }else{
        HTLog(@"create Tabel Fail:%@",_dataBase.lastErrorMessage);
    }
}

- (void)setupPurchaseSearchHistoryTable
{
    HTLog(@"打开数据库成功");
    //我们打开数据库之后 需要创建表格
    /*
     create table if not exists app(id varchar(32),name varchar(128),pic varchar(1024))
     */
    NSString *sql =[NSString stringWithFormat: @"create table if not exists %@ ( %@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT)",kPurchaseTableName,kColID,kColTitle];
    BOOL isSuccess = [_dataBase executeUpdate:sql];
    if (isSuccess) {
        HTLog(@"create  %@ Tabel Success",kPurchaseTableName);
    }else{
        HTLog(@"create Tabel Fail:%@",_dataBase.lastErrorMessage);
    }
}


#pragma mark - public methods
- (void)saveHomeSerachRecordWithTitle:(NSString*)title
{
    NSString *sql =[NSString stringWithFormat: @"INSERT INTO %@ (%@) VALUES (?)",kTableName,kColTitle];
    [self.dataBase executeUpdate:sql,title];
}

- (NSArray*)queryHomeSerachRecord
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ order by ID desc",kTableName];
    FMResultSet *s = [_dataBase executeQuery:sql];
    NSMutableArray *records = [NSMutableArray array];
    while ([s next]) {
        //retrieve values for each record
        NSInteger identifier = [s intForColumn:kColID];
        NSString *title = [s objectForColumnName:kColTitle];
        NSDictionary *record = [NSDictionary dictionaryWithObjectsAndKeys:title,kColTitle,@(identifier),kColID, nil];
        [records addObject:record];
    }
    return records;
}

- (BOOL)deleteHomeSerachRecord:(NSDictionary*)record
{
    NSNumber *identifier = [record objectForKey:kColID];
    NSString *sql =[NSString stringWithFormat: @"DELETE FROM %@ WHERE ID = ?",kTableName];
    return [self.dataBase executeUpdate:sql,identifier];
}


- (BOOL)deleteHomeSerachAllRecord
{
    NSString *sql =[NSString stringWithFormat: @"DELETE FROM %@",kTableName];
    return [self.dataBase executeUpdate:sql];
}

//采购界面数据存储
- (void)savePurchaseSerachRecordWithTitle:(NSString*)title
{
    NSString *sql =[NSString stringWithFormat: @"INSERT INTO %@ (%@) VALUES (?)",kPurchaseTableName,kColTitle];
    [self.dataBase executeUpdate:sql,title];
}

- (NSArray*)queryPurchaseSerachRecord
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ order by ID desc",kPurchaseTableName];
    FMResultSet *s = [_dataBase executeQuery:sql];
    NSMutableArray *records = [NSMutableArray array];
    while ([s next]) {
        //retrieve values for each record
        NSInteger identifier = [s intForColumn:kColID];
        NSString *title = [s objectForColumnName:kColTitle];
        NSDictionary *record = [NSDictionary dictionaryWithObjectsAndKeys:title,kColTitle,@(identifier),kColID, nil];
        [records addObject:record];
    }
    return records;
}

- (BOOL)deletePurchaseSerachRecord:(NSDictionary*)record
{
    NSNumber *identifier = [record objectForKey:kColID];
    NSString *sql =[NSString stringWithFormat: @"DELETE FROM %@ WHERE ID = ?",kPurchaseTableName];
    return [self.dataBase executeUpdate:sql,identifier];
}

- (BOOL)deletePurchaseSerachAllRecord
{
    NSString *sql =[NSString stringWithFormat: @"DELETE FROM %@",kPurchaseTableName];
    return [self.dataBase executeUpdate:sql];
}

#pragma mark - public methods
+ (NSString*)decryptStringWith:(NSString*)crptStr
{
    NSString *decryptStr = [SecurityUtil decryptAES:crptStr];
    return decryptStr;
}

+ (id)dictionaryWithJsonStr:(id)jsonStr
{
    NSString *decryptStr = [self decryptStringWith:jsonStr];
    NSError *error = nil;
    NSData *data = [decryptStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return dict;
}



@end
