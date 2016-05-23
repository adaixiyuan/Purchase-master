//
//  GoodsShowViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/23.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "GoodsShowViewController.h"

@interface GoodsShowViewController ()

@end

@implementation GoodsShowViewController

- (id)initWithDelegate:(id<MWPhotoBrowserDelegate>)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.displayActionButton = NO;
        self.displayNavArrows = NO;
        self.displaySelectionButtons = NO;
        self.alwaysShowControls = NO;
        self.zoomPhotosToFill = NO;
        self.enableGrid = NO;
        self.startOnGrid = NO;
        self.enableSwipeToDismiss = NO;
        self.autoPlayOnAppear = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = NAVBARCOLOR;
    UIImage *backImage = [UIImage imageNamed:@"nav_back"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    [backButton setImage: backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton] animated:NO];
}
- (void)backAction:(id)sender{
    
    if (self.selectGoodsIndex) {
        self.selectGoodsIndex(self.currentIndex);
    }
    [self.navigationController popViewControllerAnimated: YES];
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
