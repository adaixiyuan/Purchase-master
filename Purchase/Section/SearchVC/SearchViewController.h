//
//  SearchViewController.h
//  Purchase
//
//  Created by luoheng on 16/5/7.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController

@property (nonatomic, copy) void (^beginSearchWithTheKey)(NSString *des,NSString *brand,NSString *type, NSString *date, NSString *location);

@end
