//
//  AppDelegate.h
//  Purchase
//
//  Created by luoheng on 16/5/2.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,RESideMenuDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)changeRootVC;
- (void)goToLoginVC;
@end

