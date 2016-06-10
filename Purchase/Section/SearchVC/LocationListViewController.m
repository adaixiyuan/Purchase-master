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
static const float BarHeight = 44;

@interface LocationListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UITableView    *theTableView;
@property (nonatomic, strong) UISearchBar    *searchBar;
@property (nonatomic, strong) NSArray        *locationList;
@property (nonatomic, strong) NSMutableArray *searchList;

@end

@implementation LocationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSInternationalString(@"地址", @"地址");
    [self.view addSubview:self.theTableView];
    self.theTableView.tableHeaderView = self.searchBar;
    
    // 获取地点列表
    [MYMBProgressHUD showHudWithMessage:NSInternationalString(@"请稍等···", @"请稍等···") InView:self.view];
    [self getLocationRequest];
}
#pragma mark - Request
- (void)getLocationRequest
{
    [[NetworkManager sharedInstance] startRequestWithURL:kLocactionRequest method:RequestPost parameters:nil result:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MYMBProgressHUD hideHudFromView:self.view];
        self.locationList = [[NSArray alloc]initWithArray:[responseObject objectForKey:@"data"]];
        self.searchList = [[NSMutableArray alloc]initWithArray:self.locationList];
        [self.theTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MYMBProgressHUD hideHudFromView:self.view];
        [MYMBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"]];
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchList.count;
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
    NSDictionary *locationDic = [[NSDictionary alloc]initWithDictionary:self.searchList[indexPath.row]];
    
    NSString *loc_str = NSInternationalString(@"地点", @"地点");
    NSString *need_str = NSInternationalString(@"待采购总数", @"待采购总数");
    cell.textLabel.text = [NSString stringWithFormat:@"%@：%@",loc_str,SAFE_STRING([locationDic objectForKey:@"loc_name"])];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@：%@",need_str,SAFE_NUMBER([locationDic objectForKey:@"wait_to_buy"])];
    
    if ([[SearchInfoModel shareInstance].locationStr isEqualToString:SAFE_STRING(cell.textLabel.text)]) {
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
     NSDictionary *locationDic = [[NSDictionary alloc]initWithDictionary:self.searchList[indexPath.row]];
    if (self.saveTheAddress) {
        self.saveTheAddress(SAFE_STRING([locationDic objectForKey:@"loc_name"]));
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
    self.searchList = [[NSMutableArray alloc]initWithArray:self.locationList];
    [self.theTableView reloadData];
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    [self.searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.searchList != nil) {
        [self.searchList removeAllObjects];
    }
    
    for (NSDictionary *locationDic in self.locationList) {
        if ([[locationDic objectForKey:@"loc_name"] rangeOfString:searchText].location != NSNotFound) {
            [self.searchList addObject:locationDic];
        }
    }
    [self.theTableView reloadData];
}
#pragma mark - Set && Get
- (UITableView *)theTableView
{
    if (_theTableView == nil) {
        _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
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
- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, BarHeight)];
        _searchBar.showsCancelButton = YES;
        _searchBar.placeholder = NSInternationalString(@"请输入搜索的内容", @"请输入搜索的内容");
        _searchBar.delegate = self;
        _searchBar.backgroundColor = [UIColor whiteColor];
    }
    return _searchBar;
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
