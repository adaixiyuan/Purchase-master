//
//  NSTimer+EOCBlocksSupport.h
//  CLife
//
//  Created by Newman on 15/8/18.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSTimer (EOCBlocksSupport)

+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                     block:(void(^)())block
                                   repeats:(BOOL)repeats;
@end
