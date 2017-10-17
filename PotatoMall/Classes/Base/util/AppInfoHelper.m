//
//  AppInfoHelper.m
//  PotatoMall
//
//  Created by taotao on 26/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "AppInfoHelper.h"

@implementation AppInfoHelper


+ (NSString*)currentDeviceIdentifier
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString*)shortVersionString
{
    NSString *version = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}


+ (NSArray*)arrayWithPlistFile:(NSString*)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    return array;
}


@end
