//
//  GoodsShowViewController.h
//  Purchase
//
//  Created by luoheng on 16/5/8.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger , VCType) {
    HomePageVC = 0,   // 首页
    PurchaseVC = 1,   // 采购单
    RecordVC = 2,     // 记录
    GoodsInfoVC = 3,  // 商品信息
};

@interface GoodsShowViewController : BaseViewController

@property (nonatomic, assign) VCType    vcType;
@property (nonatomic, strong) NSArray   *dataList;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) void (^selectGoodsIndex)(NSInteger index);

@end
