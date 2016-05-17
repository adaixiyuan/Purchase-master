//
//  RecordInfoModel.h
//  Purchase
//
//  Created by luoheng on 16/5/14.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordInfoModel : NSObject

@property (nonatomic, strong) NSString  *sid;// 记录唯一ID
@property (nonatomic, strong) NSString  *des;// 商品描述
@property (nonatomic, assign) NSInteger quantity;// 个数
@property (nonatomic, strong) NSString  *brand_name;// 品牌名称
@property (nonatomic, strong) NSString  *create_dt;// 创建时间
@property (nonatomic, strong) NSString  *imgUrl;
@property (nonatomic, assign) NSInteger type;// 1表示采购记录， 2表示订货记录

@end
