//
//  CodeScanViewController.h
//  Purchase
//
//  Created by luoheng on 16/5/5.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "BaseViewController.h"

@interface CodeScanViewController : BaseViewController

@property (nonatomic, copy) void (^sendTheCode)(NSString *str);

@end
