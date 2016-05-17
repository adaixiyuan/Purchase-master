//
//  BaseViewController.m
//  fresh
//
//  Created by HeT on 15/11/11.
//  Copyright © 2015年 100fresh. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.barTintColor = NAVBARCOLOR;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = viewBgColor;
    UIImage *backImage = [UIImage imageNamed:@"nav_back"];
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, 0, 30, 30);
    [self.backButton setImage: backImage forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.backButton] animated:NO];
}
#pragma mark - Event
- (void)backAction:(id)sender{
    if (self.isPresented) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated: YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
    NSLog(@"----- dealloc------");
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
