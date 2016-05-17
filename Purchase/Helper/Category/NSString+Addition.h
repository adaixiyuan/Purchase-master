//
//  NSString+Addition.h
//  fresh
//
//  Created by HeT on 15/11/14.
//  Copyright © 2015年 100fresh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

- (NSString *)getMd5_32Bit_String;

+ (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters; //字典拼接

- (NSString *)decodeFromPercentEscapeString;

- (NSDictionary *)getJSONStringToDictionary;

- (float)getHeightBoundingRectWithFont:(UIFont *)font andWidth:(float)width;

- (float)getWidthBoundingRectWithFont:(UIFont *)font andHeight:(float)height;

+ (BOOL)stringContainsEmoji:(NSString *)string;//包含表情字符

+ (BOOL)isMobileNumber:(NSString *)mobileNum;//手机号验证

+ (BOOL)isValidEmail:(NSString *)emailStr;//检查邮箱是否有效

+ (BOOL)isValidPassword:(NSString *)passwordStr;//检查密码格式是否正确

@end
