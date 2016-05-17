//
//  MyStore.h
//  123
//
//  Created by HeT on 15/11/23.
//  Copyright © 2015年 lh. All rights reserved.
//

#import "YTKKeyValueStore.h"

@interface MyStore : YTKKeyValueStore

// GCD单例
+ (MyStore *)sharedInstance;

@end
