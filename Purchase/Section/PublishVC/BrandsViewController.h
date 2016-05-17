//
//  BrandListViewController.h
//  Purchase
//
//  Created by luoheng on 16/5/14.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "BaseViewController.h"

@interface BrandsViewController : BaseViewController

@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *brandStr;

@property (nonatomic,copy) void (^selectTheBrand)(NSString *brandStr);

@end
