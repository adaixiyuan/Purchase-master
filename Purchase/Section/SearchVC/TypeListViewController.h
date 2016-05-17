//
//  TypeListViewController.h
//  Purchase
//
//  Created by luoheng on 16/5/15.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "BaseViewController.h"

@interface TypeListViewController : BaseViewController

@property (nonatomic, copy) void (^selectTheType)(NSString *typeStr,NSString *typeID,NSArray *typeIDs);

@end
