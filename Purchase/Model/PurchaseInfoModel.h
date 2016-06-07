//
//  PurchaseInfoModel.h
//  Purchase
//
//  Created by luoheng on 16/5/16.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchaseInfoModel : NSObject

@property (nonatomic, strong) NSString *brand_name;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *goods_no;  // 条码
@property (nonatomic, strong) NSString *img_url;
@property (nonatomic, strong) NSString *locs;      // 购买地
@property (nonatomic, assign) NSInteger num_iid;   // 淘宝numIid
@property (nonatomic, assign) float     price;
@property (nonatomic, assign) NSInteger sid;       // 采购单记录唯一标示
@property (nonatomic, assign) NSInteger sku_id;    // 淘宝skuid
@property (nonatomic, assign) NSInteger type;      // 1为淘宝订单， 2 为收货订单，3为实时发布商品单
@property (nonatomic, assign) NSInteger wait_to_buy; // 待采购个数

@end
