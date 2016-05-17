//
//  SearchInfoModel.h
//  Purchase
//
//  Created by luoheng on 16/5/15.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , FromVCType) {
    FromPurchaseVC = 0,   // 采购单
    FromRecordVC = 1,     // 记录
    FromGoodsInfoVC = 2,  // 商品信息
};

@interface SearchInfoModel : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, assign) FromVCType fromType;

@property (nonatomic, strong) NSString   *keyStr;
@property (nonatomic, strong) NSString   *brandName;

@property (nonatomic, strong) NSString   *typeName;
@property (nonatomic, strong) NSString   *typeID;

@property (nonatomic, strong) NSString   *dateStr;
@property (nonatomic, strong) NSString   *locationStr;

@property (nonatomic, strong) NSString   *domain;// BuyRecord, Order, Product
@property (nonatomic, strong) NSArray    *typeList;

- (void)clean;

@end
