//
//  AppDelegate.m
//  Purchase
//
//  Created by luoheng on 16/5/2.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomePageViewController.h"
#import "LeftViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 开启登录通知
    [self startObserveLoginNotification];
    
    // 创建数据库
    [[MyStore sharedInstance] createTableWithName:kUserTable];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NavigationController *nav = [[NavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)changeRootVC
{
    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:[[HomePageViewController alloc] init]];
    
    LeftViewController *leftViewController = [[LeftViewController alloc] init];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController leftMenuViewController:leftViewController rightMenuViewController:nil];
    sideMenuViewController.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    sideMenuViewController.contentViewScaleValue = 1.0;
    sideMenuViewController.panGestureEnabled = NO;
    self.window.rootViewController = sideMenuViewController;
}
- (void)goToLoginVC
{
    NavigationController *nav = [[NavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
    [self.window setRootViewController:nav];
}
- (void)startObserveLoginNotification
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(presentLoginViewController:)
                                                 name: kNotificationLogin
                                               object: nil];
}
- (void)stopObserveLoginNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLogin object:nil];
}
- (void)presentLoginViewController: (NSNotification *)notification
{
    // 关闭通知
    [self stopObserveLoginNotification];
    NSDictionary *loginStatusDic = notification.userInfo;
    if ([[loginStatusDic objectForKey:@"loginStatus"] isEqualToString:@"loginOutTime"]) {
        
        LoginViewController *login = [[LoginViewController alloc]init];
        login.isPresented = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.window.rootViewController presentViewController:login
                                                          animated:YES
                                                        completion:nil];
        });
        __weak typeof (self) weakSelf = self;
        login.startLoginNotification = ^{
            [weakSelf startObserveLoginNotification];
        };
    }
}
#pragma mark RESideMenu Delegate
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{

}
- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
   
}
- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    
}
- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
   
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
