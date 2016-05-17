//
//  LocationListViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/17.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "LocationListViewController.h"
#import "SearchInfoModel.h"

static const float RowHeight = 48;

@interface LocationListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSArray     *locationList;

@end

@implementation LocationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"地址", @"地址");
    [self.view addSubview:self.theTableView];
    
    // 获取地点列表
    [MYMBProgressHUD showHudWithMessage:NSLocalizedString(@"请稍等···", @"请稍等···") InView:self.view];
    [self getLocationRequest];
}
#pragma mark - Request
- (void)getLocationRequest
{
    [[NetworkManager sharedInstance] startRequestWithURL:kLocactionRequest method:RequestPost parameters:nil result:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MYMBProgressHUD hideHudFromView:self.view];
        self.locationList = [[NSArray alloc]initWithArray:[responseObject objectForKey:@"data"]];
        [self.theTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MYMBProgressHUD hideHudFromView:self.view];
        [MYMBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"]];
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locationList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RowHeight*SizeScaleHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        cell.textLabel.font = [UIFont customFontOfSize:14];
        cell.textLabel.textColor = SHALLOWBLACK;
        cell.detailTextLabel.font = [UIFont customFontOfSize:14];
        cell.detailTextLabel.textColor = SHALLOWBLACK;
    }
    NSDictionary *locationDic = [[NSDictionary alloc]initWithDictionary:self.locationList[indexPath.row]];
    cell.textLabel.text = [NSString stringWithFormat:@"地点：%@",SAFE_STRING([locationDic objectForKey:@"loc_name"])];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"待采购总数:%@",SAFE_NUMBER([locationDic objectForKey:@"wait_to_buy"])];
    
    NSMutableArray *locationList = [[NSMutableArray alloc]initWithArray:[[SearchInfoModel shareInstance].locationStr componentsSeparatedByString:@","]];
    if ([locationList containsObject:SAFE_STRING(cell.textLabel.text)]) {
        cell.textLabel.textColor = NAVBARCOLOR;
        cell.detailTextLabel.textColor = NAVBARCOLOR;
    }else{
        cell.textLabel.textColor = SHALLOWBLACK;
        cell.detailTextLabel.textColor = SHALLOWBLACK;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableArray *locationList = [[NSMutableArray alloc]initWithArray:[[SearchInfoModel shareInstance].locationStr componentsSeparatedByString:@","]];
    if ([locationList containsObject:SAFE_STRING(cell.textLabel.text)]) {
        [locationList removeObject:SAFE_STRING(cell.textLabel.text)];
    }else{
        [locationList addObject:SAFE_STRING(cell.textLabel.text)];
    }

    NSString *locationName = [locationList componentsJoinedByString:@","];
    if (self.saveTheAddress) {
        self.saveTheAddress(locationName);
    }
    [tableView reloadData];
}
#pragma mark - Set && Get
- (UITableView *)theTableView
{
    if (_theTableView == nil) {
        _theTableView = [[AutoTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
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
