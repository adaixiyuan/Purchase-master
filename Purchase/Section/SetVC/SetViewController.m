//
//  SetViewController.m
//  Purchase
//
//  Created by luoheng on 16/6/10.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "SetViewController.h"

static const float RowHeight = 44;

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSString    *languageName;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.languageName = [[NSUserDefaults standardUserDefaults] objectForKey:InternationalLanguage];
    if (!self.languageName) {
        NSArray * languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        self.languageName = [languages objectAtIndex:0];
    }
    self.navigationItem.title = NSInternationalString(@"设置", @"设置");
    [self.view addSubview:self.theTableView];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont customFontOfSize:14];
        cell.textLabel.textColor = SHALLOWBLACK;
        cell.detailTextLabel.font = [UIFont customFontOfSize:14];
        cell.detailTextLabel.textColor = SHALLOWBLACK;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = NSInternationalString(@"语言", @"语言");
    if ([self.languageName isEqualToString:@"zh-Hans"]) {
        cell.detailTextLabel.text = NSInternationalString(@"简体中文", @"简体中文");
    }else if ([self.languageName isEqualToString:@"en"]){
        cell.detailTextLabel.text = NSInternationalString(@"英语", @"英语");
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    [UIActionSheet showInView:self.view
                    withTitle:NSInternationalString(@"语言", @"语言")
            cancelButtonTitle:NSInternationalString(@"取消", @"取消")
       destructiveButtonTitle:nil
            otherButtonTitles:@[NSInternationalString(@"简体中文", @"简体中文"),NSInternationalString(@"英语", @"英语")]
                     tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                         if(buttonIndex == 0){
                             weakSelf.languageName = @"zh-Hans";
                             [[NSUserDefaults standardUserDefaults] setObject:weakSelf.languageName forKey:InternationalLanguage];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             [MYMBProgressHUD showMessage:NSInternationalString(@"正在设置语言~", @"正在设置语言~")];
                             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeLanguage object:nil];
                             weakSelf.navigationItem.title = NSInternationalString(@"设置", @"设置");
                             [weakSelf.theTableView reloadData];
                         }else if(buttonIndex == 1){
                             weakSelf.languageName = @"en";
                             [[NSUserDefaults standardUserDefaults] setObject:weakSelf.languageName forKey:InternationalLanguage];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             [MYMBProgressHUD showMessage:NSInternationalString(@"正在设置语言~", @"正在设置语言~")];
                             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeLanguage object:nil];
                             weakSelf.navigationItem.title = NSInternationalString(@"设置", @"设置");
                             [weakSelf.theTableView reloadData];
                         }
    }];
}
#pragma mark - Set && Get
- (UITableView *)theTableView
{
    if (_theTableView == nil) {
        _theTableView = [[AutoTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
        _theTableView.backgroundColor = [UIColor clearColor];
        _theTableView.delegate = self;
        _theTableView.dataSource = self;
        _theTableView.tableFooterView = [[UIView alloc]init];
        _theTableView.separatorColor = separateLineColor;
        if ([_theTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_theTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([_theTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_theTableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
    return _theTableView;
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
