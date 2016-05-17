//
//  NavigationController.m
//  fresh
//
//  Created by HeT on 15/11/11.
//  Copyright © 2015年 100fresh. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 导航栏背景色
    [self.navigationBar setBarTintColor:NAVBARCOLOR];
    // 导航栏控件着色
    [self.navigationBar setTintColor: [UIColor whiteColor]];
    // Translucent
    [self.navigationBar setTranslucent: NO];
    // 导航栏文本属性，颜色，字体等
    [self.navigationBar setTitleTextAttributes:@{
       NSForegroundColorAttributeName: [UIColor whiteColor],
       NSFontAttributeName: [UIFont customFontWithName:@"HelveticaNeue-CondensedBlack"
                                            size: 18],
       }
     ];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
