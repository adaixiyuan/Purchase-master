//
//  BaseViewController.h
//  fresh
//
//  Created by HeT on 15/11/11.
//  Copyright © 2015年 100fresh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL     isPresented;// 模态？ push
@property (nonatomic, strong) UIButton *backButton;

- (void)backAction: (id)sender;

@end
