//
//  HomeBaseViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/2.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "HomeBaseViewController.h"

@interface HomeBaseViewController ()

@end

@implementation HomeBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *backImage = [UIImage imageNamed:@"bar_menu"];
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, 0, 30, 30);
    [self.backButton setImage: backImage forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.backButton] animated:NO];
}
- (void)backAction:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
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
