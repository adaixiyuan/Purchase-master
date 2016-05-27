//
//  UserInfoModel.h
//  Purchase
//
//  Created by luoheng on 16/5/12.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) NSString *role; // 用户角色  buyer
@property (nonatomic, strong) NSString *user_name; // 用户名
@property (nonatomic, assign) NSInteger user_sid; // 用户唯一识别ID

@end
