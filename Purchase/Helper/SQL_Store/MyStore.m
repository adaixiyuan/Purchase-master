//
//  MyStore.m
//  123
//
//  Created by HeT on 15/11/23.
//  Copyright © 2015年 lh. All rights reserved.
//

#import "MyStore.h"

@implementation MyStore

// GCD单例
+ (MyStore *)sharedInstance
{
    static MyStore *__singletion = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        __singletion = [[self alloc] initDBWithName:@"Data.db"];
        
    });
    
    return __singletion;
}

@end
