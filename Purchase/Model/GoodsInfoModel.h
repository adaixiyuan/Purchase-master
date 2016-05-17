//
//  GoodsInfoModel.h
//  Purchase
//
//  Created by luoheng on 16/5/12.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsInfoModel : NSObject

@property (nonatomic, assign) NSInteger sid; // 商品唯一id
@property (nonatomic, strong) NSString  *des; // 商品描述
@property (nonatomic, strong) NSString  *brand_name; // 商品品牌
@property (nonatomic, assign) NSInteger sell_qty; // 历史销售个数
@property (nonatomic, assign) NSInteger stock_qty; // 库存数
@property (nonatomic, assign) float     recent_price; // 最近购入价格
@property (nonatomic, assign) NSInteger wait_to_buy; // 待采购个数
@property (nonatomic, assign) NSInteger publish_qty; // 收购个数
@property (nonatomic, strong) NSString  *num_iid; // 淘宝numIid
@property (nonatomic, strong) NSString  *sku_id; // 淘宝skuid
@property (nonatomic, strong) NSString  *goods_no; // 商品条码
@property (nonatomic, strong) NSString  *img_url; // 商品url


@end
