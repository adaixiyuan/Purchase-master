//
//  LocationListViewController.h
//  Purchase
//
//  Created by luoheng on 16/5/17.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "BaseViewController.h"

@interface LocationListViewController : BaseViewController

@property (nonatomic, copy) void (^saveTheAddress)(NSString *address);

@end
