//
//  NSDate+Additions.h
//  fresh
//
//  Created by HeT on 15/11/14.
//  Copyright © 2015年 100fresh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

+ (NSString *)getTimestamp;       //时间戳

+ (NSString *)getCurrentTime;     //获取当前时间    %H%M

+ (NSString *)getCurrentDate;     //获取当前时间    %Y-%m-%d %H:%M:%S

+ (NSString *)getCurrentStrDate;     //获取当前时间   %Y%m%d

+ (NSString *)getCurrentDateAorP; // 上下午

+ (NSDate *)gmtDateFromISO8601String:(NSString *)iso8601;

@end
