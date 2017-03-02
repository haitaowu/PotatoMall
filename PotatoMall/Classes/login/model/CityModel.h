//
//  CityModel.h
//  PotatoMall
//
//  Created by taotao on 02/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

/**名称*/
@property (nonatomic,copy) NSString *name;
/**主键ID*/
@property (nonatomic,strong) NSNumber *cityId;
/**父级ID*/
@property (nonatomic,strong) NSNumber *parentId;

@end
