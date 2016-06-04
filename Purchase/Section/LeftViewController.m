//
//  LeftViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/2.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftViewCell.h"
#import "HomePageViewController.h"
#import "PurchaseOrderViewController.h"
#import "RecordViewController.h"
#import "GoodsInfoViewController.h"
#import "GoodsPublishViewController.h"
#import "AppDelegate.h"
#import "SearchInfoModel.h"

static const float SectionHeadHeight = 150;
static const float RowHeight = 42;

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSArray     *titles;
@property (nonatomic, strong) NSArray     *iconImages;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = NAVBARCOLOR;
    [self.view addSubview:self.theTableView];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SectionHeadHeight*SizeScaleHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, SectionHeadHeight*SizeScaleHeight)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIImageView *headImageView = [[UIImageView alloc]init];
    headImageView.backgroundColor = [UIColor clearColor];
    headImageView.layer.cornerRadius = 30;
    [headImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"head_image"]];
    [headView addSubview:headImageView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont customFontOfSize:16];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = [UserInfoModel shareInstance].user_name;
    [headView addSubview:nameLabel];
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).with.offset(60);
        make.centerY.equalTo(headView).with.offset(0);
        make.width.and.height.equalTo(@60);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_bottom).with.offset(10);
        make.centerX.equalTo(headImageView.mas_centerX).with.offset(0);
    }];
    
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RowHeight*SizeScaleHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LeftViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.titleLabel.text = self.titles[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:self.iconImages[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[SearchInfoModel shareInstance] clean];
    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setContentViewController:[[NavigationController alloc] initWithRootViewController:[[HomePageViewController alloc]init]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            [self.sideMenuViewController setContentViewController:[[NavigationController alloc] initWithRootViewController:[[PurchaseOrderViewController alloc]init]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 2:
            [self.sideMenuViewController setContentViewController:[[NavigationController alloc] initWithRootViewController:[[RecordViewController alloc]init]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 3:
            [self.sideMenuViewController setContentViewController:[[NavigationController alloc] initWithRootViewController:[[GoodsInfoViewController alloc]init]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 4:{
            if ([[UserInfoModel shareInstance].role isEqualToString:@"buyer"]) {
                // 设置
                
            }else{
                [self.sideMenuViewController setContentViewController:[[NavigationController alloc] initWithRootViewController:[[GoodsPublishViewController alloc]init]] animated:YES];
                [self.sideMenuViewController hideMenuViewController];
            }
        }
            break;
        case 5:{
            if ([[UserInfoModel shareInstance].role isEqualToString:@"buyer"]) {
                [self.sideMenuViewController hideMenuViewController];
                [UIAlertView showWithTitle:NSLocalizedString(@"确认退出登录？", @"确认退出登录？") message:nil cancelButtonTitle:NSLocalizedString(@"取消", @"取消") otherButtonTitles:@[NSLocalizedString(@"确定", @"确定")] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [app goToLoginVC];
                    }
                }];
            }else{
                // 设置
            }
        }
            break;
        case 6:{
            [self.sideMenuViewController hideMenuViewController];
            [UIAlertView showWithTitle:NSLocalizedString(@"确认退出登录？", @"确认退出登录？") message:nil cancelButtonTitle:NSLocalizedString(@"取消", @"取消") otherButtonTitles:@[NSLocalizedString(@"确定", @"确定")] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [app goToLoginVC];
                }
            }];
        }
            break;
        default:
            break;
    }
}
#pragma mark - Set && Get
- (UITableView *)theTableView
{
    if (_theTableView == nil) {
        _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _theTableView.backgroundColor = [UIColor clearColor];
        _theTableView.delegate = self;
        _theTableView.dataSource = self;
        _theTableView.bounces = NO;
        _theTableView.tableFooterView = [[UIView alloc]init];
        _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _theTableView;
}
- (NSArray *)titles
{
    if (_titles == nil) {
        [UserInfoModel shareInstance].role = @"buyer+";
        if([[UserInfoModel shareInstance].role isEqualToString:@"buyer"]){
            _titles = @[NSLocalizedString(@"首页", @"首页"),NSLocalizedString(@"采购单", @"采购单"),NSLocalizedString(@"记录", @"记录"),NSLocalizedString(@"商品信息", @"商品信息"),NSLocalizedString(@"设置", @"设置"),NSLocalizedString(@"退出登录", @"退出登录")];
        }else{
           _titles = @[NSLocalizedString(@"首页", @"首页"),NSLocalizedString(@"采购单", @"采购单"),NSLocalizedString(@"记录", @"记录"),NSLocalizedString(@"商品信息", @"商品信息"),NSLocalizedString(@"商品发布", @"商品发布"),NSLocalizedString(@"设置", @"设置"),NSLocalizedString(@"退出登录", @"退出登录")];
        }

    }
    return _titles;
}
- (NSArray *)iconImages
{
    if (_iconImages == nil) {
        _iconImages = @[@"home_page",@"order_icon",@"record_icon",@"goods_icon",@"publish_icon",@"set_icon",@"exit_icon"];
    }
    return _iconImages;
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
