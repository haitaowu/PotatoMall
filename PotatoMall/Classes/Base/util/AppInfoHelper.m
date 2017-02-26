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
@end
