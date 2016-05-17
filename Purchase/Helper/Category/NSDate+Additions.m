//
//  NSDate+Additions.m
//  fresh
//
//  Created by HeT on 15/11/14.
//  Copyright © 2015年 100fresh. All rights reserved.
//

#import "NSDate+Additions.h"
#include <time.h>
#include <xlocale.h>

#define ISO8601_MAX_LEN 25

@implementation NSDate (Additions)

+ (NSString *)getTimestamp{
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat: @"%ld", (long)(time)];
    return timestamp;
}
+ (NSString *)getCurrentTime{
    time_t rawtime;
    struct tm * timeinfo;
    time ( &rawtime );
    timeinfo = localtime(&rawtime);
    char buffer[20]={0};
    strftime(buffer, 20, "%H%M", timeinfo);
    NSString * dateTime = [NSString stringWithFormat:@"%c%c:%c%c",buffer[0],buffer[1],buffer[2],buffer[3]];
    return dateTime;
}
+ (NSString *)getCurrentDate
{
    time_t rawtime;
    struct tm * timeinfo;
    time ( &rawtime );
    timeinfo = localtime(&rawtime);
    char buffer[20]={0};
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}
+ (NSString*)getCurrentStrDate
{
    time_t rawtime;
    struct tm * timeinfo;
    time ( &rawtime );
    timeinfo = localtime(&rawtime);
    char buffer[20]={0};
    strftime(buffer, 80, "%Y-%m-%d", timeinfo);
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}
+ (NSString *)getCurrentDateAorP
{
    NSString *dayTime;
    time_t rawtime;
    struct tm * timeinfo;
    time ( &rawtime );
    timeinfo = localtime(&rawtime);
    char buffer[20]={0};
    strftime(buffer, 20, "%H", timeinfo);
    NSString * dateTime = [NSString stringWithFormat:@"%c%c",buffer[0],buffer[1]];
    if ([dateTime integerValue] > 6 && [dateTime integerValue] < 11) {
        dayTime = @"早上好！";
    }else if ([dateTime integerValue] >= 11 && [dateTime integerValue] < 14){
        dayTime = @"中午好！";
    }else if ([dateTime integerValue] >= 14 && [dateTime integerValue] < 19){
        dayTime = @"下午好！";
    }else{
        dayTime = @"晚上好！";
    }
    return dayTime;
}
+ (NSDate *)gmtDateFromISO8601String:(NSString *)iso8601 {
    if (!iso8601) {
        return nil;
    }
    
    const char *str = [iso8601 cStringUsingEncoding:NSUTF8StringEncoding];
    char newStr[ISO8601_MAX_LEN];
    bzero(newStr, ISO8601_MAX_LEN);
    
    size_t len = strlen(str);
    if (len == 0) {
        return nil;
    }
    
    // UTC dates ending with Z
    if (len == 20 && str[len - 1] == 'Z') {
        memcpy(newStr, str, len - 1);
        strncpy(newStr + len - 1, "+0000\0", 6);
    }
    
    // Timezone includes a semicolon (not supported by strptime)
    else if (len == 25 && str[22] == ':') {
        memcpy(newStr, str, 22);
        memcpy(newStr + 22, str + 23, 2);
    }
    
    // Fallback: date was already well-formatted OR any other case (bad-formatted)
    else {
        memcpy(newStr, str, len > ISO8601_MAX_LEN - 1 ? ISO8601_MAX_LEN - 1 : len);
    }
    
    // Add null terminator
    newStr[sizeof(newStr) - 1] = 0;
    
    struct tm tm = {
        .tm_sec = 0,
        .tm_min = 0,
        .tm_hour = 0,
        .tm_mday = 0,
        .tm_mon = 0,
        .tm_year = 0,
        .tm_wday = 0,
        .tm_yday = 0,
        .tm_isdst = -1,
    };
    //2011-01-31T19:42:36Z
    if (strptime_l(newStr, "%Y-%m-%d %H:%M:%S", &tm, NULL) == NULL) {
        return nil;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:timegm(&tm)];
}


@end
