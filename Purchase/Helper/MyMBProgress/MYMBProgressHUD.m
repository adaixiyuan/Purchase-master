//
//  MYMBProgressHUD.m
//  123
//
//  Created by HeT on 15/11/23.
//  Copyright © 2015年 lh. All rights reserved.
//

#import "MYMBProgressHUD.h"
#import "AppDelegate.h"

@implementation MYMBProgressHUD

+ (MBProgressHUD *)showHudWithMessage:(NSString *)message
{
    AppDelegate *appDeelgate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:appDeelgate.window];
    HUD.labelText = message;
    [appDeelgate.window addSubview: HUD];
    [HUD show:YES];
    return HUD;
}
+ (MBProgressHUD *)showHudWithMessage:(NSString *)message InView:(UIView *)view
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = message;
    [view addSubview: HUD];
    [HUD show:YES];
    return HUD;
}
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    AppDelegate *appDeelgate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:appDeelgate.window animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabelText = message;
    HUD.detailsLabelFont = [UIFont systemFontOfSize:15];
    HUD.margin = 15.f;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:1.5];
    if (message.length > 0) {
        return HUD;
    }else{
        return nil;
    }
}
+ (void)hideHudFromView:(UIView *)view
{
    AppDelegate *appDeelgate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [MBProgressHUD hideAllHUDsForView:appDeelgate.window animated:YES];
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

@end
