//
//  KeyNoteModel.h
//  Purchase
//
//  Created by luoheng on 16/5/18.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyNoteModel : NSObject

@property (nonatomic, strong) NSString *content;   // 内容
@property (nonatomic, strong) NSString *create_dt;  // 创建时间
@property (nonatomic, strong) NSString *create_user; // 创建者名称
@property (nonatomic, assign) NSInteger create_user_sid; // 创建者id
@property (nonatomic, strong) NSString *expire_dt; // 失效时间
@property (nonatomic, assign) NSInteger sid;  // 重点内容唯一ID
@property (nonatomic, strong) NSString *tag;  // 标注, 有可能是品牌, 或地点, 多个tag用逗号隔开
@property (nonatomic, strong) NSString *title; // 标题
@property (nonatomic, assign) NSInteger type;   // 1表示普通信息, 2 表示折扣信息
@property (nonatomic, strong) NSString *img_urls;

@end
