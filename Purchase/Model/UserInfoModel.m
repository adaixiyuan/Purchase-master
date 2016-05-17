//
//  UserInfoModel.m
//  Purchase
//
//  Created by luoheng on 16/5/12.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static UserInfoModel *_singleton = nil;
    dispatch_once(&onceToken, ^{
        _singleton = [[super allocWithZone:NULL] init];
    });
    return _singleton;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self shareInstance];
}

#pragma - implement NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
