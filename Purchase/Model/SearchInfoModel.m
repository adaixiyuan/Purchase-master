//
//  SearchInfoModel.m
//  Purchase
//
//  Created by luoheng on 16/5/15.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "SearchInfoModel.h"

@implementation SearchInfoModel

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static SearchInfoModel *_singleton = nil;
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

- (void)clean
{
    _fromType = 9999;
    
    _keyStr = nil;
    _brandName = nil;
    
    _typeName = nil;
    _typeID = nil;
    
    _dateStr = nil;
    _locationStr = nil;
    
    _domain = nil;// BuyRecord, Order, Product
    _typeList = nil;
}

@end
