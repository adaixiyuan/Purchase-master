//
//  MYMBProgressHUD.h
//  123
//
//  Created by HeT on 15/11/23.
//  Copyright © 2015年 lh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface MYMBProgressHUD : MBProgressHUD

/**
 *  添加在windows
 */
+ (MBProgressHUD *)showHudWithMessage:(NSString *)message;
/**
 *  添加在view
 */
+ (MBProgressHUD *)showHudWithMessage:(NSString *)message InView:(UIView *)view;
/**
 *  提示语
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;
/**
 *  隐藏
 */
+ (void)hideHudFromView:(UIView *)view;

@end
