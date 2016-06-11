//
//  GoodsInfoEditViewController.h
//  Purchase
//
//  Created by luoheng on 16/5/6.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "BaseViewController.h"

@interface GoodsInfoEditViewController : BaseViewController

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, copy) void (^updateTheGoodsInfo)(NSString *infoStr);

@end
